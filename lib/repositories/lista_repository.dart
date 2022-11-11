import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:supercalc/database/db.dart';
import 'package:supercalc/models/lista.dart';

class ListaRepository extends ChangeNotifier {
  late Database db;
  List<Lista> _listas = [];

  List<Lista> get getListas => _listas;

  Future<void> loadAll() async {
    db = await getDatabase();
    _listas = [];
    List<Map<String, dynamic>> listas = await db.query('listas');
    _listas.addAll(listas.map((e) => Lista.fromMap(e)));
    notifyListeners();
  }

  Future<void> update(
      {required int id,
      required nome,
      required Function onSuccess,
      required onError}) async {
    db = await getDatabase();
    try {
      int result = await db.update('listas', {'nome': nome},
          where: 'id = ? ', whereArgs: [id]);
      if (result > 0) {
        loadAll();
        onSuccess();
      } else {
        onError();
      }
    } on Expanded catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }

  Future<void> remove(
      {required int id, required Function onSuccess, required onError}) async {
    db = await getDatabase();
    try {
      int result = await db.delete('listas', where: 'id = ?', whereArgs: [id]);
      if (result > 0) {
        loadAll();
        onSuccess();
      } else {
        onError();
      }
    } on Expanded catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }

  Future<void> save(
      {required Lista lista,
      required Function onSuccess,
      required onError}) async {
    db = await getDatabase();
    try {
      int result = await db.insert('listas', {'nome': lista.nome, 'saldo': 0});
      if (result > 0) {
        loadAll();
        onSuccess();
      } else {
        onError();
      }
    } on Expanded catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }
}
