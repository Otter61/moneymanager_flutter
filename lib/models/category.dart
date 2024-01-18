import 'package:moneymanager_app/helpers/date_formatter_helper.dart';

class Category {
  final int id;
  final String name;
  int? orderRank = 0;

  final String createdAt;
  final String? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    this.orderRank,
    this.updatedAt
  });

  factory Category.fromSfliteDatabase(Map<String, dynamic> map) => Category(
    id: map['id']?.toInt() ?? 0, 
    name: map['name'] ?? '', 
    orderRank: map['orderRank'],
    createdAt: DateFormatterHelper.dateToString(
      DateTime.fromMillisecondsSinceEpoch(map['created_at'])),
    updatedAt: map['updated_at'] == null ? null : 
      DateFormatterHelper.dateToString(
      DateTime.fromMillisecondsSinceEpoch(map['updated_at']))
  );
}