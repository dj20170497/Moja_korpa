import 'dart:async';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> korpa;
  final void Function(Map<String, dynamic>) dodajUKorpu;
  final void Function(String) obrisiIzKorpe;

  const SplashScreen({
    super.key,
    required this.korpa,
    required this.dodajUKorpu,
    required this.obrisiIzKorpe,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            korpa: widget.korpa,
            dodajUKorpu: widget.dodajUKorpu,
            obrisiIzKorpe: widget.obrisiIzKorpe,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFD281),
      body: Center(
        child: SizedBox(
          height: 100,
          child: Image(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
