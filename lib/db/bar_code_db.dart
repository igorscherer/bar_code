import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bar_code/model/codigo_de_barras.dart';

class SqlHelper {
  Future<Database> initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'codigosdebarra.db'),
        onCreate: (db, version) async {
      await db.execute(
          '''CREATE TABLE codigos(id INTEGER PRIMARY KEY, codigoEscaneado TEXT, time TEXT)''');
    }, version: 1);
  }

  Future<void> insertCodigo(Codigo codigo) async {
    final db = await initDB();

    await db.insert(
      'codigos',
      codigo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Codigo>> codigos() async {
    final db = await initDB();

    final List<Map<String, dynamic>> maps = await db.query('codigos');

    return List.generate(maps.length, (i) {
      return Codigo(
        id: maps[i]['id'],
        codigoEscaneado: maps[i]['codigoEscaneado'],
        createdTime: maps[i]['time'],
      );
    });
  }

  Future<void> updateCodigo(Codigo codigo) async {
    final db = await initDB();

    await db.update(
      'codigos',
      codigo.toMap(),
      where: 'id = ?',
      whereArgs: [codigo.id],
    );
  }

  Future<void> deleteCodigo(int id) async {
    final db = await initDB();

    await db.delete(
      'codigos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllCodigos() async {
    final db = await initDB();

    await db.delete(
      'codigos',
    );
  }
}
