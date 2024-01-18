import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/expense.dart';
import 'package:moneymanager_app/models/wallet.dart';
import 'package:moneymanager_app/widgets/create_expense_widget.dart';
import 'package:moneymanager_app/widgets/expense_list.dart';
import '../models/category.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key, required this.category, required this.wallet, required this.refreshPage});

  final Category category;
  final Wallet wallet;
  final void Function() refreshPage;

  @override
  State<StatefulWidget> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  Future<List<Expense>>? expenses;
  double balanceTotal = 0; 
  final expenseDB = ExpenseDB(); 

 @override
  void initState() {
    super.initState();
    balanceTotal = widget.wallet.balanceTotal;
    fetchExpenses();
  }
  
  void fetchExpenses() async {
    setState(() {
      expenses = expenseDB.getItems(categoryid: widget.category.id, name: widget.wallet.name);
    });
    widget.refreshPage();
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.wallet.name} Expense List',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Remaining Balance: ',
                style: TextStyle(fontSize: 14)),
              Text('P${NumberFormatterHelper.decimalToString(balanceTotal)}',
                style: const TextStyle(fontSize: 14)),
            ],
          )
        ],
      ),
    ),
    body: FutureBuilder<List<Expense>>(
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
            : Column(
                children: [
                  Expanded(
                    child: ExpenseList(
                      expenses: expenseData,
                      onTap: (expense) async {
                        showDialog(
                          context: context, 
                          builder: (_) => CreateExpenseWidget(
                            wallet: widget.wallet,
                            expense: expense,
                            onSubmit: (name, amount, description, updatedAt) async {
                              await expenseDB.updateItem(
                                id: expense.id, 
                                name: name, 
                                amount:  amount, 
                                description: description,
                                updatedAt: updatedAt);
                              if(!mounted) return;
                              fetchExpenses();
                              balanceTotal -= (-1 * (expense.amount - amount));
                              Navigator.of(context).pop();
                            },
                          )
                        );
                      },
                    )
                  )
                ],
              );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context, 
          builder: (_) => CreateExpenseWidget(
            wallet: widget.wallet,
            onSubmit: (name, amount, description, createdAt) async {
              await expenseDB.createItem(
                categoryId: widget.category.id, 
                name: name, 
                amount: amount, 
                description: description,
                createdAt: createdAt);
              if(!mounted) return;
              fetchExpenses();
              balanceTotal -= amount;
              Navigator.of(context).pop();
            },
          )
          );
      },
    ),
  );
}