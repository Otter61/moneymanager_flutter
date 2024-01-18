import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/wallet.dart';
import 'package:moneymanager_app/widgets/wallet_item.dart';

class WalletList extends StatelessWidget {
  const WalletList({
    super.key, 
    required this.onExpense,
    required this.wallet,
    required this.onTap,
    required this.onRemove
    });

  final List<Wallet> wallet;
  final void Function(Wallet wallet) onExpense;
  final void Function(Wallet wallet) onTap;
  final void Function(Wallet wallet) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallet.length,
      itemBuilder: (ctx, index) {
      final walletitem = wallet[index];
      return Dismissible(
              key: Key(walletitem.name),
              onDismissed: (direction) {
                wallet.removeAt(index);
                onRemove(walletitem);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${walletitem.name} is removed')));
              },
              confirmDismiss: (direction) async {
                if (walletitem.balanceTotal == 0) {
                  return true;
                }
                return false;
              },
              child: InkWell(
                child: WalletItem(walletitem, onExpense: onExpense),
                onTap: () {
                  onTap(walletitem);
                },
              ),
            );
      } 
    );
  }
}