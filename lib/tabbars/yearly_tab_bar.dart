import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';

class YearlyTabBar extends StatefulWidget {
  const YearlyTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<YearlyTabBar> createState() => _YearlyTabBarState();
}

class _YearlyTabBarState extends State<YearlyTabBar> {

  final expenseDB = ExpenseDB();
  Future<List<Dashboard>>? expenses;
  
  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getGroupedYearlyExpense();
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