import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/budget.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_service.dart';
import '../models/wallet.dart';

class BudgetDB {
  final String tableName = "budget";

  Future<List<Map<String, Object?>>> createDefaultValues(Database database) async {
    List<Map<String, Object?>> currentValues = [];
    List<String> names = ['Daily Food Budget', 
                          'Investment to deposit', 
                          'Rent and Utilities',
                          'Electric Bill',
                          'Groceries'];

    final query = await database.rawQuery('''
      SELECT id FROM category
    ''');
    List<int> ids = query.map((e) => int.parse(e['id'].toString())).toList();

    for (int indx = 0; indx < ids.length; indx++) {
      for (int indy = 0; indy < names.length; indy++) {
          var tempAmount = NumberFormatterHelper.decimalToString(Random().nextDouble() * 25000 + 10000);
          currentValues.add({
          'category_id': ids[indx],
          'name': names[indy],
          'amount': NumberFormatterHelper.stringToDecimal(tempAmount),
          'created_at': DateTime(2023, Random().nextInt(11) + 1, Random().nextInt(26) + 1).millisecondsSinceEpoch
          });
      }
    }
    return currentValues;
  }

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        amount REAL DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') AS INTEGER)),
        updated_at INTEGER,
        FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE NO ACTION ON UPDATE NO ACTION 
      )""");

      // var listofDevaultValues = await createDefaultValues(database);
      // for (int indx = 0; indx < listofDevaultValues.length; indx++) {
      //     await database.insert(
      //       tableName, 
      //       listofDevaultValues[indx]
      //     );
      // }
  }

  Future<int> createItem({required int categoryId, required String name, required double amount, DateTime? createdAt}) async {
    final database = await DatabaseService().database;
    final id = await database.insert(tableName, {
      'category_id': categoryId,
      'name': name,
      'amount': amount,
      'created_at': createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch
    },conflictAlgorithm: ConflictAlgorithm.fail);
    return id;
  }

  Future<List<Wallet>> getGroupedItems({required int categoryid}) async {
    final database = await DatabaseService().database;
    final query = await database.rawQuery('''
      SELECT category_id, name, SUM(amount) as amount FROM $tableName
      WHERE category_id = ?
      Group By category_id, name
     ''', [categoryid]);
    return query.map((budget) => Budget.toMap(budget)).toList();
  }

  Future<List<Budget>> getItems({required int categoryid, String? name}) async {
    final database = await DatabaseService().database;
    String whereCond = 'category_id = ?';
    List<Object> whereArgs = [categoryid];
    if (name != null && name.isNotEmpty) 
    {
      whereCond += ' and name = ?';
      whereArgs.add(name);
    }
    final query = await database.query(tableName, where: whereCond, whereArgs: whereArgs, orderBy: "created_at DESC");
    return query.map((budget) => Budget.fromSfliteDatabase(budget)).toList();
  }

  Future<Budget> getItem(int id) async {
    final database = await DatabaseService().database;
    final query = await database.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);
    return Budget.fromSfliteDatabase(query.first);
  }

  Future<int> updateItem({required int id, required String name, required double amount, DateTime? updatedAt}) async {
    final database = await DatabaseService().database;
    final result = await database.update(tableName, {
      'name': name,
      'amount': amount,
      'updated_at': updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch
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

  Future<void> deleteItems(String name) async {
    final database = await DatabaseService().database;
    try {
      await database.delete(tableName, where: "name = ?", whereArgs: [name]);
    }
    catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}