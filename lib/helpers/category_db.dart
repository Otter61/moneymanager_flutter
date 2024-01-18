import 'package:flutter/material.dart';
import 'package:moneymanager_app/database/database_service.dart';
import 'package:moneymanager_app/models/category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDB {
  final String tableName = 'category';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        orderRank INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') AS INTEGER)),
        updated_at INTEGER
      )""");

    await database.insert(
      tableName, 
      {
        'id': 0,
        'name': 'Cash (On Hand)',
        'orderRank': 0,
        'created_at': DateTime.now().millisecondsSinceEpoch
      }
    );

    await database.insert(
      tableName, 
      {
        'id': 1,
        'name': 'BPI',
        'orderRank': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch
      }
    );

    await database.insert(
      tableName, 
      {
        'id': 2,
        'name': 'UnionBank',
        'orderRank': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch
      }
    );
  }

  Future<int> createItem({required String name}) async {
    final database = await DatabaseService().database;
    final id = await database.insert(tableName, {
      'name': name,
      'orderRank': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch
    },conflictAlgorithm: ConflictAlgorithm.fail);
    return id;
  }

  Future<List<Category>> getItems() async {
    final database = await DatabaseService().database;
    final query = await database.query(tableName, orderBy: "orderRank");
    return query.map((category) => Category.fromSfliteDatabase(category)).toList();
  }

  Future<Category> getItem(int id) async {
    final database = await DatabaseService().database;
    final query = await database.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);
    return Category.fromSfliteDatabase(query.first);
  }

  Future<int> updateItem({required int id, required String name}) async {
    final database = await DatabaseService().database;
    final result = await database.update(tableName, {
      'name': name,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    }, where: "id = ?", whereArgs: [id],
    conflictAlgorithm: ConflictAlgorithm.rollback);
    return result;
  }

  Future<void> deleteItem(int id) async {
    final database = await DatabaseService().database;
    try {
      await database.delete(tableName, where: "id = ?", whereArgs: [id]);
    }
    catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}