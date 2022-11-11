import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supercalc/models/lista_items.dart';

import '../database/db.dart';

class ItemsRepository extends ChangeNotifier {
  late Database db;
  List<ListaItems> _items = [];

  List<ListaItems> get getListaItems => _items;

  Future<void> loadAll(int listId) async {
    db = await getDatabase();
    _items = [];
    List<Map<String, dynamic>> items = await db
        .query('lista_items', where: 'listaId = ?', whereArgs: [listId]);
    print(items);
    _items.addAll(items.map((e) => ListaItems.fromMap(e)));
    notifyListeners();
  }

  Future<void> save(
      {required ListaItems item,
      required Function onSuccess,
      required onError}) async {
    db = await getDatabase();
    try {
      // print(item.valor);
      int result = await db.insert('lista_items', {
        'descricao': item.descricao,
        'valor': item.valor,
        'listaId': item.listaId
      });
      if (result > 0) {
        await updateTotalList(item.listaId);
        loadAll(item.listaId);
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

  Future<void> updateTotalList(int listaId) async {
    var sumResult = await db.rawQuery(
        'SELECT sum(valor) as total from lista_items where listaId = ? ',
        [listaId]);

    await db.update('listas', {'saldo': sumResult[0]['total'] ?? 0},
        where: 'id = ? ', whereArgs: [listaId]);
  }

  Future<void> remove(
      {required int id,
      required listId,
      required Function onSuccess,
      required onError}) async {
    db = await getDatabase();
    try {
      int result =
          await db.delete('lista_items', where: 'id = ?', whereArgs: [id]);
      if (result > 0) {
        await updateTotalList(listId);
        loadAll(listId);
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
