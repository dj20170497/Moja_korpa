import 'package:flutter/material.dart';
import '../widgets/KategorijaWidget.dart';
import 'PiceScreen.dart';
import 'KorpaScreen.dart'; // Ne zaboravi da dodaš import za korpu

class HomeScreen extends StatelessWidget {
  final Map<String, Map<String, dynamic>> korpa;
  final void Function(Map<String, dynamic> proizvod) dodajUKorpu;
  final void Function(String id) obrisiIzKorpe;

  const HomeScreen({
    super.key,
    required this.korpa,
    required this.dodajUKorpu,
    required this.obrisiIzKorpe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: 'logo',
          child: SizedBox(
            height: 100,
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
        ),
        backgroundColor: const Color(0xFFFFD281),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KorpaScreen(
                korpaMapa: korpa,
                obrisiIzKorpe: obrisiIzKorpe,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFFFF2CC),
        child: const Icon(Icons.shopping_cart, color: Colors.black),
      ),
      body: ListView(
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
        ],
      ),
    );
  }
}
