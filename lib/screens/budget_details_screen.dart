import 'package:flutter/material.dart';
import 'package:moneymanager_app/pages/budget_page.dart';

import '../models/category.dart';

class BudgetDetailsScreen extends StatelessWidget {
  const BudgetDetailsScreen({super.key, required this.category, required this.walletNames, required this.selectedWallet, required this.refreshPage});

  final Category category;
  final String selectedWallet;
  final List<String> walletNames;

  final void Function() refreshPage;

  @override
  Widget build(BuildContext context) {
    return BudgetPage(category: category, refreshPage: refreshPage, walletNames: walletNames, selectedWallet: selectedWallet);
  }
}