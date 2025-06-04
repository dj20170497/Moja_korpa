import 'package:flutter/material.dart';
import '../widgets/KategorijaWidget.dart';
import 'PiceScreen.dart';

class KategorijaScreen extends StatelessWidget {
  final Map<String, Map<String, dynamic>> korpa;
  final void Function(Map<String, dynamic> proizvod) dodajUKorpu;
  final void Function(String id) obrisiIzKorpe;

  const KategorijaScreen({
    super.key,
    required this.korpa,
    required this.dodajUKorpu,
    required this.obrisiIzKorpe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorije'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          KategorijaWidget(
            naziv: 'Piće',
            animacija: 'assets/images/juice.json',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PiceScreen(
                    korpa: korpa,
                    dodajUKorpu: dodajUKorpu,
                    obrisiIzKorpe: obrisiIzKorpe,
                  ),
                ),
              );
            },
          ),
          // Dodaj više kategorija ako želiš
        ],
      ),
    );
  }
}
