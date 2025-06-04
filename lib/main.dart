import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/KategorijaScreen.dart';
import 'screens/PiceScreen.dart';
import 'screens/ProizvodiScreen.dart';
import 'screens/KorpaScreen.dart';
import 'screens/SplashScreen.dart'; // ← dodato

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Map<String, dynamic>> korpa = {};

  void dodajUKorpu(Map<String, dynamic> proizvod) {
    final id = proizvod['id'].toString();
    setState(() {
      if (korpa.containsKey(id)) {
        korpa[id]!['kolicina']++;
      } else {
        korpa[id] = {...proizvod, 'kolicina': 1};
      }
    });
  }

  void obrisiIzKorpe(String id) {
    setState(() {
      korpa.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: SplashScreen( // ← prikazujemo Splash ekran
        korpa: korpa,
        dodajUKorpu: dodajUKorpu,
        obrisiIzKorpe: obrisiIzKorpe,
      ),
    );
  }
}
