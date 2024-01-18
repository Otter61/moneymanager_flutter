import 'package:flutter/material.dart';
import 'package:moneymanager_app/pages/wallet_page.dart';

import '../models/category.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return WalletPage(category: category);
  }
}