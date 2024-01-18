import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/expense.dart';

import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key, 
    required this.expenses,
    required this.onTap
    });

  final List<Expense> expenses;
  final void Function(Expense category) onTap;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => InkWell(
          child: ExpenseItem(expenses[index]),
          onTap: () {
            onTap(expenses[index]);
          },
      )
    );
  }
}