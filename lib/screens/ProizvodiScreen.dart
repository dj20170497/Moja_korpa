import 'package:flutter/material.dart';
import '../database/baza_service.dart';
import 'KorpaScreen.dart';

class ProizvodiScreen extends StatefulWidget {
  final String podkategorija;
  final Map<String, Map<String, dynamic>> korpa;
  final void Function(Map<String, dynamic>) dodajUKorpu;
  final void Function(String) obrisiIzKorpe;

  const ProizvodiScreen({
    super.key,
    required this.podkategorija,
    required this.korpa,
    required this.dodajUKorpu,
    required this.obrisiIzKorpe,
  });

  @override
  State<ProizvodiScreen> createState() => _ProizvodiScreenState();
}

class _ProizvodiScreenState extends State<ProizvodiScreen> {
  List<Map<String, dynamic>> proizvodi = [];
  List<Map<String, dynamic>> filtriraniProizvodi = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    _ucitajProizvode();
  }

  Future<void> _ucitajProizvode() async {
    final rezultat =
        await BazaService.getProizvodiZaPodkategoriju(widget.podkategorija);
    setState(() {
      proizvodi = rezultat;
      filtriraniProizvodi = rezultat;
    });
  }

  void _filtrirajProizvode(String unos) {
    setState(() {
      query = unos.toLowerCase();
      filtriraniProizvodi = proizvodi
          .where((proizvod) =>
              proizvod['naziv'] != null &&
              proizvod['naziv'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  void _prikaziCeneZaProizvod(Map<String, dynamic> proizvod) {
    final marketi = [
      'univerexport',
      'mega_maxi',
      'lidl',
      'maxi',
      'probar',
      'dis',
      'idea',
      'roda',
      'ananas'
    ];

    final dostupniMarketi = marketi.where((market) {
      final cenaStr = proizvod[market]?.toString() ?? '-';
      return cenaStr != '-' && cenaStr.trim().isNotEmpty;
    }).toList();

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              proizvod['naziv'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: dostupniMarketi.map((market) {
                final cenaStr = proizvod[market]?.toString() ?? '-';
                return Container(
                  width: MediaQuery.of(context).size.width / 2 - 32,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD281),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/marketi_logo/$market.webp',
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.store),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$cenaStr RSD',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD281),
        title: Text(
          widget.podkategorija,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KorpaScreen(
                korpaMapa: widget.korpa,
                obrisiIzKorpe: widget.obrisiIzKorpe,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFFFF2CC),
        child: const Icon(Icons.shopping_cart, color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Pretraži proizvode...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filtrirajProizvode,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: filtriraniProizvodi.length,
              itemBuilder: (context, index) {
                final proizvod = filtriraniProizvodi[index];
                final id = proizvod['id'].toString();

                final cene = [
                  proizvod['univerexport'],
                  proizvod['mega_maxi'],
                  proizvod['lidl'],
                  proizvod['maxi'],
                  proizvod['probar'],
                  proizvod['dis'],
                  proizvod['idea'],
                  proizvod['roda'],
                  proizvod['ananas'],
                ]
                    .where((c) =>
                        c != null && c != '-' && c.toString().trim().isNotEmpty)
                    .map((c) =>
                        double.tryParse(c.toString().replaceAll(',', '.')))
                    .whereType<double>()
                    .toList();

                double minCena = 0;
                double maxCena = 0;

                if (cene.isNotEmpty) {
                  cene.sort();
                  minCena = cene.first;
                  maxCena = cene.last;
                }

                return GestureDetector(
                  onTap: () => _prikaziCeneZaProizvod(proizvod),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD281),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: proizvod['slika'] != null &&
                                    proizvod['slika']
                                        .toString()
                                        .startsWith('http')
                                ? Image.network(
                                    proizvod['slika'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          size: 60);
                                    },
                                  )
                                : const Icon(Icons.image_not_supported,
                                    size: 60),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          proizvod['naziv'] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cene.isNotEmpty
                              ? '${minCena.toStringAsFixed(2)} - ${maxCena.toStringAsFixed(2)}'
                              : 'Nema cene',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFF2CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              widget.dodajUKorpu(proizvod);
                              setState(() {});
                            },
                            child: Text(
                              widget.korpa.containsKey(id)
                                  ? 'Dodato: ${widget.korpa[id]!['kolicina']}'
                                  : 'Dodaj',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
