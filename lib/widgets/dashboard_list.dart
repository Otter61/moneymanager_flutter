import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/dashboard.dart';
import 'package:moneymanager_app/widgets/dashboard_item.dart';

class DashboardList extends StatelessWidget {
  const DashboardList({
    super.key, 
    required this.expenses
  });

  final List<Dashboard> expenses;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return Card(
          child: DashBoardItem(expenses[index]),
        );
      }
    );
  }
}