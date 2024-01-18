import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';

class QuarterlyTabBar extends StatefulWidget {
  const QuarterlyTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<QuarterlyTabBar> createState() => _QuarterlyTabBarState();
}

enum QuarterLabel {
  quarter1('Quarter 1', 1),
  quarter2('Quarter 2', 2),
  quarter3('Quarter 3', 3),
  quarter4('Quarter 4', 4);

  const QuarterLabel(this.label, this.value);
  final String label;
  final int value;
}

class _QuarterlyTabBarState extends State<QuarterlyTabBar> {
  final TextEditingController quarterController = TextEditingController();
  QuarterLabel? selectedWeek;
  final expenseDB = ExpenseDB();
  Future<List<Dashboard>>? expenses;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getGroupedQuarterlyExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Dashboard>>(
        future: expenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            final expenseData = snapshot.data!;

            return expenseData.isEmpty
            ? const Center(
              child: Text('No Expenses...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),
              ),
            )
            : ListView.builder(
                itemCount: expenseData.length,
                itemBuilder: (context, index) {
                  final expense = expenseData[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(expense.categoryName, 
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                                  Text('P${NumberFormatterHelper.decimalToString(expense.amount)}')
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              Text(expense.dateValue!)
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}