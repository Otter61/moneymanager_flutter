import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/models/dashboard.dart';
import 'package:moneymanager_app/tabbars/monthly_tab_bar.dart';
import 'package:moneymanager_app/tabbars/quarterly_tab_bar.dart';
import 'package:moneymanager_app/tabbars/weekly_tab_bar.dart';
import 'package:moneymanager_app/tabbars/yearly_tab_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<Dashboard>>? expenses;
  final expenseDB = ExpenseDB();

  @override
  void initState() {
    super.initState();
      fetchExpenses();
  }
  
  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getGroupedExpense();
    });
  }

   @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Primary and secondary TabBar'),
            bottom: const TabBar(
              dividerColor: Colors.transparent,
              tabs: <Widget>[
                Tab(
                  text: 'Weekly',
                  icon: Icon(Icons.calendar_view_week),
                ),
                Tab(
                  text: 'Monthly',
                  icon: Icon(Icons.calendar_month),
                ),
                Tab(
                  text: 'Quarterly',
                  icon: Icon(Icons.analytics),
                ),
                Tab(
                  text: 'Yearly',
                  icon: Icon(Icons.assessment),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              WeeklyTabBar('Weekly'),
              MonthlyTabBar('Monthly'),
              QuarterlyTabBar('Quarterly'),
              YearlyTabBar('Yearly'),
            ],
          ),
        ),
      );
    }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Dashboard',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //     ),
  //     body: FutureBuilder<List<Dashboard>>(
  //       future: expenses,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         else {
  //           final expenseData = snapshot.data!;

  //           return expenseData.isEmpty
  //           ? const Center(
  //             child: Text('No Dashboard...',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 28
  //             ),
  //             ),
  //           )
  //           : Column(
  //             children: [
  //               Expanded(
  //                 child: DashboardList(expenses: expenseData))
  //             ],
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
}