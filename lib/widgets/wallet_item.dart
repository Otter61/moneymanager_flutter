import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import '../models/wallet.dart';

class WalletItem extends StatelessWidget {
  const WalletItem(
    this.wallet,
    {super.key, 
    required this.onExpense});

  final Wallet wallet;
  final void Function(Wallet wallet) onExpense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4
          ),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wallet.name, 
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Text('P${NumberFormatterHelper.decimalToString(wallet.balanceTotal)}'),
                        const SizedBox(width: 10),
                        Ink(
                          height: 30,
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 242, 172, 191),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))
                          ),
                          child: IconButton(
                            onPressed: () {
                              onExpense(wallet);
                            }, 
                            icon: const Icon(Icons.attach_money_rounded),
                            color: const Color.fromARGB(255, 70, 34, 85),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  )
                ],
              ),
        ),
      );
  }
}