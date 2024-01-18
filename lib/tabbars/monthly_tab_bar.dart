import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/dashboard.dart';

class MonthlyTabBar extends StatefulWidget {
  const MonthlyTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<MonthlyTabBar> createState() => _MonthlyTabBarState();
}

// enum MonthLabel {
//   january('January', 1),
//   february('February', 2),
//   march('March', 3),
//   april('April', 4),
//   may('May', 5),
//   june('June', 6),
//   july('July', 7),
//   august('August', 8),
//   september('September', 9),
//   october('October', 10),
//   november('November', 11),
//   december('December', 12);

//   const MonthLabel(this.label, this.value);
//   final String label;
//   final int value;
// }

class _MonthlyTabBarState extends State<MonthlyTabBar> {

  final TextEditingController monthController = TextEditingController();
  // MonthLabel? selectedMonth;
  final expenseDB = ExpenseDB();
  Future<List<Dashboard>>? expenses;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getGroupedMonthlyExpense();
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


  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       const Text('Select Month'),
  //       DropdownButton<MonthLabel>(
  //         value: selectedMonth,
  //         onChanged: (MonthLabel? newValue) {
  //           setState(() {
  //             selectedMonth = newValue!;
  //           });
  //         },
  //         isExpanded: true,
  //         items: MonthLabel.values.map<DropdownMenuItem<MonthLabel>>((MonthLabel value) {
  //           return DropdownMenuItem<MonthLabel>(
  //             value: value,
  //             child: Text(value.label),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );

