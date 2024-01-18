import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/budget.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem(
    this.budget,
    {super.key});

  final Budget budget;

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
                  Text(budget.name, 
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                  Text('P${NumberFormatterHelper.decimalToString(budget.amount)}')
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(budget.createdAt)
                ],
              )
            ],
          ),
        ),
      );
  }
}