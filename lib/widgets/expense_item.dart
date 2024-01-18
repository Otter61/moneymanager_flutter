import 'package:flutter/material.dart';

import '../helpers/number_formatter_helper.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.expense,
    {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8
          ),
          child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(expense.name, 
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                      Text('P${NumberFormatterHelper.decimalToString(expense.amount)}')
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${expense.description}'),
                  Text(expense.createdAt)
                ],
              )
            ],
          ),
        ),
      );
  }
}