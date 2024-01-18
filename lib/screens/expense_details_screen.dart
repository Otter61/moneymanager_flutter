import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/wallet.dart';
import 'package:moneymanager_app/pages/expense_page.dart';

import '../models/category.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({super.key, required this.category, required this.wallet, required this.refreshPage});

  final Category category;
  final Wallet wallet;
  final void Function() refreshPage;

  @override
  Widget build(BuildContext context) {
    return ExpensePage(category: category, refreshPage:  refreshPage, wallet: wallet);
  }
}