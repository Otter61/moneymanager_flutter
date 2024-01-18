import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';

class WeeklyTabBar extends StatefulWidget {
  const WeeklyTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<WeeklyTabBar> createState() => _WeeklyTabBarState();
}

enum WeekLabel {
  week1('Week 1', 1),
  week2('Week 2', 2),
  week3('Week 3', 3),
  week4('Week 4', 4);

  const WeekLabel(this.label, this.value);
  final String label;
  final int value;
}

class _WeeklyTabBarState extends State<WeeklyTabBar> {
  final TextEditingController weekController = TextEditingController();
  WeekLabel? selectedWeek;
  final expenseDB = ExpenseDB();
  Future<List<Dashboard>>? expenses;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getGroupedWeeklyExpense();
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       const Text('Select Week'),
  //       DropdownButton<WeekLabel>(
  //         value: selectedWeek,
  //         onChanged: (WeekLabel? newValue) {
  //           setState(() {
  //             selectedWeek = newValue!;
  //           });
  //         },
  //         isExpanded: true,
  //         items: WeekLabel.values.map<DropdownMenuItem<WeekLabel>>((WeekLabel value) {
  //           return DropdownMenuItem<WeekLabel>(
  //             value: value,
  //             child: Text(value.label),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }
}