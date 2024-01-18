import 'package:moneymanager_app/helpers/date_formatter_helper.dart';
import 'package:moneymanager_app/models/wallet.dart';

class Expense {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final double amount;

  final String createdAt;
  final String? updatedAt;

  Expense({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.amount,
    required this.createdAt,
    this.updatedAt
  });

  factory Expense.fromSfliteDatabase(Map<String, dynamic> map) => Expense(
      id: map['id']?.toInt() ?? 0, 
      categoryId: map['category_id'],
      name: map['name'] ?? '', 
      description: map['description'] ?? '',
      amount: map['amount'] ?? 0,
      createdAt: DateFormatterHelper.dateToString(
        DateTime.fromMillisecondsSinceEpoch(map['created_at'])),
      updatedAt: map['updated_at'] == null ? null : 
        DateFormatterHelper.dateToString(
        DateTime.fromMillisecondsSinceEpoch(map['updated_at']))
    );

  static Wallet toMap(Map<String, dynamic> map) {
    return Wallet(
      categoryId: map['category_id'], 
      name: map['name'], 
      budgetTotal: 0, 
      expenseTotal: map['amount']
      );
  }
}