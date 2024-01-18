import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';
import 'package:moneymanager_app/models/expense.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_service.dart';
import '../models/wallet.dart';

class ExpenseDB {
  final String tableName = "expense";

    Future<List<Map<String, Object?>>> createDefaultValues(Database database) async {
    List<Map<String, Object?>> currentValues = [];
    List<String> descs = ['Daily Food Budget', 
                          'Investment to deposit', 
                          'Rent and Utilities',
                          'Electric Bill',
                          'Groceries'];

    final query = await database.rawQuery('''
      SELECT category_id, name, amount from budget
    ''');

    for (int indx = 0; indx < query.length; indx++) {
      // for (int indy = 0; indy < descs.length; indy++) {
          var budgetAmount = NumberFormatterHelper.stringToDecimal(query[indx]['amount'].toString()) ?? 0;
          while(budgetAmount > 0) {
            var tempAmount = NumberFormatterHelper.stringToDecimal(NumberFormatterHelper.decimalToString(Random().nextDouble() * 1000 + 5)) ?? 5;
            if (budgetAmount > tempAmount) {
              budgetAmount -= tempAmount;
            }
            else {
              tempAmount = budgetAmount;
              budgetAmount = 0;
            }
            currentValues.add({
            'category_id': query[indx]['category_id'],
            'name': query[indx]['name'],
            'description': descs[Random().nextInt(5)],
            'amount': tempAmount,
            'created_at': DateTime(2023, Random().nextInt(11) + 1, Random().nextInt(26) + 1).millisecondsSinceEpoch
            });
          }
      // }
    }
    return currentValues;
  }

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
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

  Future<int> createItem({required int categoryId, 
                          required String name, 
                          required double amount, 
                          String? description, 
                          DateTime? createdAt}) async {
    final database = await DatabaseService().database;
    final id = await database.insert(tableName, {
      'category_id': categoryId,
      'name': name,
      'amount': amount,
      'description': description,
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
    return query.map((expense) => Expense.toMap(expense)).toList();
  }

  Future<List<Dashboard>> getGroupedExpense() async {
    final database = await DatabaseService().database;
    final query = await database.rawQuery('''
      SELECT b.name, SUM(amount) as amount FROM $tableName a LEFT JOIN category b
      ON a.category_id = b.id
      GROUP By a.category_id
    ''');
    return query.map((d) => Dashboard.toMap(d)).toList();
  }

  Future<List<Dashboard>> getGroupedWeeklyExpense() async {
    final database = await DatabaseService().database;
    var query = await database.rawQuery('''
      SELECT b.name, 
      strftime('%Y-%W', datetime(a.created_at / 1000, 'unixepoch', 'localtime')) as dateValue,
      SUM(amount) as amount FROM $tableName a LEFT JOIN category b
      ON a.category_id = b.id
      GROUP By a.category_id, dateValue
      ORDER By dateValue DESC, b.name ASC
    ''');

    return query.map((d) => Dashboard.toMap(d)).toList();
  }

  Future<List<Dashboard>> getGroupedMonthlyExpense() async {
    final database = await DatabaseService().database;
    var query = await database.rawQuery('''
      SELECT b.name, 
      strftime('%Y-%m', datetime(a.created_at / 1000, 'unixepoch', 'localtime')) as dateValue,
      SUM(amount) as amount FROM $tableName a LEFT JOIN category b
      ON a.category_id = b.id
      GROUP By a.category_id, dateValue
      ORDER By dateValue DESC, b.name ASC
    ''');

    return query.map((d) => Dashboard.toMap(d)).toList();
  }

  Future<List<Dashboard>> getGroupedQuarterlyExpense() async {
    final database = await DatabaseService().database;
    var query = await database.rawQuery('''
      SELECT b.name, 
      strftime('%Y-Q', datetime(a.created_at / 1000, 'unixepoch', 'localtime')) ||
      CAST((ROUND((strftime('%m', datetime(a.created_at / 1000, 'unixepoch', 'localtime')) / 3.0 + 0.3), 0)) AS INTEGER) as dateValue,
      SUM(amount) as amount FROM $tableName a LEFT JOIN category b
      ON a.category_id = b.id
      GROUP By a.category_id, dateValue
      ORDER By dateValue DESC, b.name ASC 
    ''');
    return query.map((d) => Dashboard.toMap(d)).toList();
  }

  Future<List<Dashboard>> getGroupedYearlyExpense() async {
    final database = await DatabaseService().database;
    var query = await database.rawQuery('''
      SELECT b.name, 
      strftime('%Y', datetime(a.created_at / 1000, 'unixepoch', 'localtime')) as dateValue,
      SUM(amount) as amount FROM $tableName a LEFT JOIN category b
      ON a.category_id = b.id
      GROUP By a.category_id, dateValue
      ORDER By dateValue DESC, b.name ASC 
    ''');

    return query.map((d) => Dashboard.toMap(d)).toList();
  }

  Future<List<Expense>> getItems({required int categoryid, required String name}) async {
    final database = await DatabaseService().database;
    final query = await database.query(tableName, where: 'category_id = ? And name = ?', whereArgs: [categoryid, name], orderBy: "created_at DESC");
    return query.map((expense) => Expense.fromSfliteDatabase(expense)).toList();
  }

  Future<Expense> getItem(int id) async {
    final database = await DatabaseService().database;
    final query = await database.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);
    return Expense.fromSfliteDatabase(query.first);
  }

  Future<int> updateItem({required int id, 
                          required String name, 
                          required double amount, 
                          String? description, 
                          DateTime? updatedAt}) async {
    final database = await DatabaseService().database;
    final result = await database.update(tableName, {
      'name': name,
      'amount': amount,
      'description': description,
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