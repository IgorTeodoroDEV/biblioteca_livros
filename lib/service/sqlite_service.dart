import 'package:biblioteca_livros/models/favorites.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, sinopse TEXT NOT NULL, img TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> createItem(Favorite favorite) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert('Favorites', favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Favorite>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Favorites');
    return queryResult.map((e) => Favorite.fromMap(e)).toList();
  }

  Future<void> deleteItem(String id) async {
    final db = await initializeDB();
    try {
      await db.delete("Favorites", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
