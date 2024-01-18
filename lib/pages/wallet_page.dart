import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/budget_db.dart';
import 'package:moneymanager_app/helpers/expense_db.dart';
import 'package:moneymanager_app/models/wallet.dart';
import 'package:moneymanager_app/widgets/wallet_list.dart';

import '../helpers/number_formatter_helper.dart';
import '../models/category.dart';
import '../screens/budget_details_screen.dart';
import '../screens/expense_details_screen.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key, required this.category});

  final Category category;

  @override
  State<StatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future<List<Wallet>>? wallets;

  double balanceTotal = 0;
  List<String> walletNames = [];

  final budgetDB = BudgetDB();
  final expenseDB = ExpenseDB();

  @override
  void initState() {
    super.initState();

    fetchWallets();
  }
  
  void fetchWallets() async {
    final budgetList = await budgetDB.getGroupedItems(categoryid: widget.category.id);
    final expenseList = await expenseDB.getGroupedItems(categoryid: widget.category.id);

    List<Wallet> updatedWallets = [];

    if (budgetList.isNotEmpty) {
      balanceTotal = 0;
      walletNames = [];
      for (var budget in budgetList) {
        var matchingExpense = expenseList.
                                  firstWhere((expense) => 
                                  expense.name == budget.name, 
                                  orElse: () => Wallet(
                                    categoryId: -1, 
                                    name: '', 
                                    budgetTotal: 0, 
                                    expenseTotal: 0));
        var expenseTotal = matchingExpense.expenseTotal;
        var wallet = Wallet(
          categoryId: budget.categoryId, 
          name: budget.name, 
          budgetTotal: budget.budgetTotal, 
          expenseTotal: expenseTotal);
        updatedWallets.add(wallet);
        balanceTotal += wallet.balanceTotal;
        walletNames.add(wallet.name);
      }
    }
    
    setState(() {
      wallets = Future.value(updatedWallets);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.category.name} Wallet List',
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
    body: FutureBuilder<List<Wallet>> (
      future: wallets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData) {
          final walletData = snapshot.data!;

          return walletData.isEmpty
            ? const Center(
              child: Text('No Wallets...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),
              ),
            )
            : Column(
                children: [
                  Expanded(
                    child: WalletList(
                      wallet: walletData,
                      onExpense: (wallet) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ExpenseDetailsScreen(
                              category: widget.category,
                              wallet: wallet,
                              refreshPage: () {
                                fetchWallets();
                              })
                            )
                          );
                      },
                      onTap: (wallet) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (ctx) => BudgetDetailsScreen(
                              category: widget.category, 
                              walletNames: walletNames, 
                              selectedWallet: wallet.name,
                              refreshPage: () {
                                fetchWallets();
                                })
                              ));
                      },
                      onRemove: (wallet) {
                        expenseDB.deleteItems(wallet.name);
                        budgetDB.deleteItems(wallet.name);
                        fetchWallets();
                      },
                    )
                  )
                ],
              );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2)),
          FloatingActionButton(
            heroTag: 'budgetButton',
            child: const Icon(Icons.wallet_rounded),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BudgetDetailsScreen(
                    category: widget.category, 
                    walletNames: walletNames,
                    selectedWallet: '',
                    refreshPage: () {
                      fetchWallets();
                    })
                    )
                  );
              }
            ),
        ],
      )
    );
}