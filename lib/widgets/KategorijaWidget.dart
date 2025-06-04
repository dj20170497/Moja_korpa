import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KategorijaWidget extends StatelessWidget {
  final String naziv;
  final String animacija;
  final VoidCallback onTap;

  const KategorijaWidget({
    super.key,
    required this.naziv,
    required this.animacija,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Lottie.asset(
            animacija,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            naziv,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
