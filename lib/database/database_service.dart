import "dart:async";

import "package:moneymanager_app/helpers/budget_db.dart";
import "package:moneymanager_app/helpers/expense_db.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

import '../helpers/category_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'moneymanager.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate:  create,
      onUpgrade: upgrade,
      singleInstance: true
    );
    return database;
  }

  Future<void> create(Database database, int version) async => {
    await CategoryDB().createTable(database),
    await BudgetDB().createTable(database),
    await ExpenseDB().createTable(database)
  };
            

  FutureOr<void> upgrade(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await deleteDatabase(await fullPath);
      await CategoryDB().createTable(database);
      await BudgetDB().createTable(database);
      await ExpenseDB().createTable(database);
    }
  }

}