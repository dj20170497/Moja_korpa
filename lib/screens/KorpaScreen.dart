import 'package:flutter/material.dart';

class KorpaScreen extends StatelessWidget {
  final Map<String, Map<String, dynamic>> korpaMapa;
  final void Function(String id) obrisiIzKorpe;

  const KorpaScreen({
    super.key,
    required this.korpaMapa,
    required this.obrisiIzKorpe,
  });

  void prikaziObracun(BuildContext context) {
    final marketi = [
      'univerexport', 'mega_maxi', 'lidl', 'maxi',
      'probar', 'dis', 'idea', 'roda', 'ananas',
    ];

    final Map<String, double> sumaPoMarketima = {};
    final Map<String, List<Map<String, dynamic>>> dostupni = {};
    final Map<String, List<Map<String, dynamic>>> nedostupni = {};
    final List<Map<String, dynamic>> potpuniMarketInfo = [];
    final List<Map<String, dynamic>> nepotpuniMarketInfo = [];

    for (final market in marketi) {
      double suma = 0;
      final dostupniProizvodi = <Map<String, dynamic>>[];
      final nedostupniProizvodi = <Map<String, dynamic>>[];

      for (final proizvod in korpaMapa.values) {
        final cenaStr = proizvod[market]?.toString() ?? '-';
        final kolicina = proizvod['kolicina'] ?? 1;

        if (cenaStr != '-' && cenaStr.trim().isNotEmpty) {
          final cena = double.tryParse(cenaStr.replaceAll(',', '.'));
          if (cena != null) {
            suma += cena * kolicina;
            dostupniProizvodi.add(proizvod);
          } else {
            nedostupniProizvodi.add(proizvod);
          }
        } else {
          nedostupniProizvodi.add(proizvod);
        }
      }

      if (dostupniProizvodi.isNotEmpty) {
        sumaPoMarketima[market] = suma;
        dostupni[market] = dostupniProizvodi;
        nedostupni[market] = nedostupniProizvodi;

        final info = {
          'market': market,
          'suma': suma,
          'sviDostupni': nedostupniProizvodi.isEmpty
        };

        if (info['sviDostupni'] == true) {
          potpuniMarketInfo.add(info);
        } else {
          nepotpuniMarketInfo.add(info);
        }
      }
    }

    potpuniMarketInfo.sort((a, b) => (a['suma'] as double).compareTo(b['suma'] as double));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ukupno po marketima'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...potpuniMarketInfo,
              ...nepotpuniMarketInfo
            ].map((info) {
              final market = info['market'];
              final total = info['suma'] as double;
              final sviDostupni = info['sviDostupni'] as bool;
              final brojNedostupnih = nedostupni[market]?.length ?? 0;

              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Detalji za $market'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dostupni proizvodi:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...dostupni[market]!.map((proizvod) {
                              final cenaStr = proizvod[market]?.toString() ?? '-';
                              final cena = double.tryParse(cenaStr.replaceAll(',', '.'));
                              return ListTile(
                                leading: proizvod['slika'] != null && proizvod['slika'].toString().startsWith('http')
                                    ? Image.network(proizvod['slika'], width: 40, height: 40, fit: BoxFit.cover)
                                    : const Icon(Icons.image_not_supported),
                                title: Text(proizvod['naziv'] ?? ''),
                                subtitle: cena != null ? Text('${cena.toStringAsFixed(2)} RSD') : null,
                              );
                            }),
                            const SizedBox(height: 16),
                            const Text('Nedostupni proizvodi:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...nedostupni[market]!.map((proizvod) => ListTile(
                                  leading: proizvod['slika'] != null && proizvod['slika'].toString().startsWith('http')
                                      ? Image.network(proizvod['slika'], width: 40, height: 40, fit: BoxFit.cover)
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(proizvod['naziv'] ?? ''),
                                )),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Zatvori'),
                        ),
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/marketi_logo/$market.webp',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, size: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${total.toStringAsFixed(2)} RSD', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              sviDostupni
                                  ? 'Svi proizvodi su dostupni'
                                  : '$brojNedostupnih proizvoda nedostaje',
                              style: TextStyle(
                                fontSize: 12,
                                color: sviDostupni ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD281),
        title: const Text('Moja korpa', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: korpaMapa.isEmpty
          ? const Center(
              child: Text(
                'Korpa je trenutno prazna.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: korpaMapa.length,
                    itemBuilder: (context, index) {
                      final id = korpaMapa.keys.elementAt(index);
                      final proizvod = korpaMapa[id]!;

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
                          .where((c) => c != null && c != '-' && c.toString().trim().isNotEmpty)
                          .map((c) => double.tryParse(c.toString().replaceAll(',', '.')))
                          .whereType<double>()
                          .toList();

                      double minCena = 0;
                      double maxCena = 0;

                      if (cene.isNotEmpty) {
                        cene.sort();
                        minCena = cene.first;
                        maxCena = cene.last;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2CC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            proizvod['slika'] != null && proizvod['slika'].toString().startsWith('http')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      proizvod['slika'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image, size: 60);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported, size: 60),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proizvod['naziv'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cene.isNotEmpty
                                        ? '${minCena.toStringAsFixed(2)} - ${maxCena.toStringAsFixed(2)} RSD'
                                        : 'Nema cene',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Količina: ${proizvod['kolicina']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => obrisiIzKorpe(id),
                              icon: const Icon(Icons.close),
                              tooltip: 'Ukloni iz korpe',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => prikaziObracun(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Obračun',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
