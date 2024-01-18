import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/budget.dart';
import 'package:moneymanager_app/widgets/budget_item.dart';

class BudgetList extends StatelessWidget {
  const BudgetList({
    super.key, 
    required this.budgets,
    required this.onTap
    });

  final List<Budget> budgets;
  final void Function(Budget category) onTap;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (ctx, index) => InkWell(
        child: BudgetItem(budgets[index]),
        onTap: () {
          onTap(budgets[index]);
        },
      )
    );
  }
}