import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BazaService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prodavnica.db');

    final file = File(path);
    if (!await file.exists()) {
      ByteData data = await rootBundle.load('assets/database/prodavnica.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  static Future<List<String>> getPodkategorijePica() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT DISTINCT podkategorija
      FROM proizvodi
      WHERE LOWER(kategorija) = 'pice' AND podkategorija IS NOT NULL
      '''
    );
    return result.map((row) => row['podkategorija'].toString()).toList();
  }

  static Future<List<Map<String, dynamic>>> getProizvodiZaPodkategoriju(String podkategorija) async {
    final db = await database;
    return await db.query(
      'proizvodi',
      where: 'LOWER(podkategorija) = ?',
      whereArgs: [podkategorija.toLowerCase()],
    );
  }
}
