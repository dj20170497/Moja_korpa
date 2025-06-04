import 'package:flutter/material.dart';
import '../database/baza_service.dart';
import 'ProizvodiScreen.dart';
import 'KorpaScreen.dart';

class PiceScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> korpa;
  final void Function(Map<String, dynamic>) dodajUKorpu;
  final void Function(String) obrisiIzKorpe;

  const PiceScreen({
    super.key,
    required this.korpa,
    required this.dodajUKorpu,
    required this.obrisiIzKorpe,
  });

  @override
  State<PiceScreen> createState() => _PiceScreenState();
}

class _PiceScreenState extends State<PiceScreen> {
  List<String> podkategorije = [];
  List<String> filtriranePodkategorije = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ucitajPodkategorije();
    _searchController.addListener(_filtrirajPodkategorije);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ucitajPodkategorije() async {
    final rezultat = await BazaService.getPodkategorijePica();
    setState(() {
      podkategorije = rezultat;
      filtriranePodkategorije = rezultat;
    });
  }

  void _filtrirajPodkategorije() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filtriranePodkategorije = podkategorije
          .where((p) => p.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD281),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Hero(
          tag: 'logo',
          child: SizedBox(
            height: 100,
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: Center(
              child: Text(
                'Piće',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pretraži podkategorije...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: filtriranePodkategorije.map((naziv) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProizvodiScreen(
                          podkategorija: naziv,
                          korpa: widget.korpa,
                          dodajUKorpu: widget.dodajUKorpu,
                          obrisiIzKorpe: widget.obrisiIzKorpe,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD281),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      naziv[0].toUpperCase() + naziv.substring(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
