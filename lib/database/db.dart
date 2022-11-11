import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  return await DB.instance.database;
}

class DB {
  DB._();
  static final instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  String get _listas => '''
      CREATE TABLE "listas" (
      "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      "nome" text NOT NULL,
      "saldo" real NOT NULL DEFAULT 0
    );
  ''';

  String get _lista_items => '''
CREATE TABLE "lista_items" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "descricao" TEXT NOT NULL,
  "valor" real NOT NULL,
  "listaId" INTEGER NOT NULL,
  CONSTRAINT "fk_lista_item" FOREIGN KEY ("listaId") REFERENCES "listas" ("id") ON DELETE CASCADE
);
''';

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'supercalc.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute(_listas);
    await db.execute(_lista_items);
  }
}
