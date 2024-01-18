import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/budget_db.dart';
import 'package:moneymanager_app/models/budget.dart';
import 'package:moneymanager_app/widgets/budget_list.dart';

import '../models/category.dart';
import '../widgets/create_budget_widget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, required this.category, required this.walletNames, required this.selectedWallet, required this.refreshPage});

  final Category category;
  final String selectedWallet;
  final List<String> walletNames;

  final void Function() refreshPage;

  @override
  State<StatefulWidget> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>{
  Future<List<Budget>>? budgets;
  List<String> walletNames = [];
  String selectedWallet = '';
  final budgetDB = BudgetDB();

  @override
  void initState() {
    super.initState();
    walletNames = widget.walletNames;
    selectedWallet = widget.selectedWallet;
    fetchBudgets();
  }
  
  void fetchBudgets() {
    setState(() {
      budgets = budgetDB.getItems(categoryid: widget.category.id, name: widget.selectedWallet);
    });
    widget.refreshPage();
  }

  void addToWalletNames(String name) {
    if(!walletNames.contains(name)) {
      walletNames.add(name);
    }
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('${widget.category.name} Budget List',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ),
    body: FutureBuilder<List<Budget>>(
      future: budgets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else {
          final budgetData = snapshot.data!;

          return budgetData.isEmpty
            ? const Center(
              child: Text('No Budgets...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),
              ),
            )
            : Column(
                children: [
                  Expanded(
                    child: BudgetList(
                      budgets: budgetData,
                      onTap: (budget) async {
                        showDialog(
                          context: context, 
                          builder: (_) => CreateBudgetWidget(
                            walletNames: walletNames,
                            selectedWallet: budget.name,
                            budget: budget,
                            onSubmit: (name, amount, updatedAt) async {
                              addToWalletNames(name);
                              await budgetDB.updateItem(
                                id: budget.id, 
                                name: name, 
                                amount:  amount, 
                                updatedAt: updatedAt);
                              if(!mounted) return;
                              fetchBudgets();
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
          builder: (_) => CreateBudgetWidget(
            walletNames: walletNames,
            selectedWallet: selectedWallet,
            onSubmit: (name, amount, createdAt) async {
              addToWalletNames(name);
              await budgetDB.createItem(
                categoryId: widget.category.id, 
                name: name, 
                amount: amount,
                createdAt: createdAt
                );
              if(!mounted) return;
              fetchBudgets();
              Navigator.of(context).pop();
            },
          )
          );
      },
    ),
  );
}