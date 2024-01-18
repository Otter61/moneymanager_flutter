import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';

class DashBoardItem extends StatelessWidget {
  final Dashboard expense;

  const DashBoardItem(
    this.expense, 
    {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(expense.categoryName, 
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold)),
            Text('P${NumberFormatterHelper.decimalToString(expense.amount)}')
          ],
        ),
      );
  }
}