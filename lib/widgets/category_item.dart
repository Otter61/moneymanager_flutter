import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
    this.category,
    {super.key,
    // required this.onBudget,
    // required this.onExpense,
    required this.onWallet});

  final Category category;
  // final void Function(Category category) onBudget;
  // final void Function(Category category) onExpense;
  final void Function(Category category) onWallet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.name, 
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    onWallet(category);
                  }, 
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  label: const Text('Wallet'),
                )
              ],
          ),
        ),
      );
  }
}