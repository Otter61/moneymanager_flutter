import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import 'package:moneymanager_app/models/expense.dart';
import 'package:moneymanager_app/models/wallet.dart';

import '../helpers/date_formatter_helper.dart';

typedef SubmitCallback = Future<void> Function(String name, double amount, String description, DateTime selectedDate);

class CreateExpenseWidget extends StatefulWidget {
  final Expense? expense;
  final Wallet wallet;
  final SubmitCallback onSubmit;

  const CreateExpenseWidget({
    super.key,
    this.expense,
    required this.wallet,
    required this.onSubmit
  });

  @override
  State<StatefulWidget> createState() => _CreateExpenseWidgetState();
}

class _CreateExpenseWidgetState extends State<CreateExpenseWidget> {
  final namecontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final numbercontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now
      );
      setState(() {
        _selectedDate = pickedDate ?? now;
      });
  }

  @override
  void initState() {
    super.initState();

    namecontroller.text = widget.expense?.name ?? widget.wallet.name;
    descriptioncontroller.text = widget.expense?.description ?? '';
    _selectedDate = widget.expense?.createdAt == null ? _selectedDate : DateFormatterHelper.stringToDate(widget.expense!.createdAt);
    amountcontroller.text = NumberFormatterHelper.decimalToString(widget.expense?.amount);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    return SingleChildScrollView(
      reverse: true,
      child: AlertDialog(
        title: Text(isEditing ? 'Edit expense' : 'Add expense'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namecontroller,
                enabled: false,
                decoration: const InputDecoration(hintText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptioncontroller,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 20,
                      child: ElevatedButton(
                      onPressed: () {
                        _showNumberInputDialog(context, 'deduct');
                      }, 
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0), // No padding
                        minimumSize: const Size(20, 20), // Rectangle size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // Rectangle corner radius
                          ),
                      ),
                      child: const Center(
                        child: Icon(Icons.remove)
                      )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: amountcontroller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: 'Amount'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Amount is required';
                            }
                            final formattedValue = NumberFormatterHelper.stringToDecimal(value);
                            if (formattedValue == null) {
                              return 'Invalid amount';
                            }
                            if (formattedValue > (widget.wallet.balanceTotal + (widget.expense?.amount ?? 0))) {
                              return 'You have insufficient balance';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 20,
                      child: ElevatedButton(
                      onPressed: () {
                        _showNumberInputDialog(context, 'add');
                      }, 
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0), // No padding
                        minimumSize: const Size(20, 20), // Rectangle size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // Rectangle corner radius
                          ),
                      ),
                      child: const Center(
                        child: Icon(Icons.add)
                      )),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormatterHelper.dateToString(_selectedDate)),
                  IconButton(
                    onPressed: _presentDatePicker, 
                    icon: const Icon(Icons.calendar_month))
                ],
              )
            ],
          )
          
    
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
            ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onSubmit(namecontroller.text, NumberFormatterHelper.stringToDecimal(amountcontroller.text)!, descriptioncontroller.text, _selectedDate);
              }
            }, 
            child: const Text('Ok')
            )
        ],
      ),
    );
  }

  void _showNumberInputDialog(BuildContext context, String actionType) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Amount to $actionType'),
          content: TextFormField(
                      controller: numbercontroller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: 'Amount'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount is required';
                          }
                        if (NumberFormatterHelper.stringToDecimal(value) == null) {
                          return 'Invalid amount';
                          }
                        return null;
                        },
                      ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel')
              ),
            TextButton(
              onPressed: () {
                if (numbercontroller.text.isNotEmpty) {
                    double amountValue = NumberFormatterHelper.stringToDecimal(amountcontroller.text) ?? 0;
                    double numberValue = NumberFormatterHelper.stringToDecimal(numbercontroller.text) ?? 0;
                    double total = 0;
                    if (actionType == 'add') {
                      total = (amountValue + numberValue);
                    }
                    else if (actionType == 'deduct') {
                      total = (amountValue - numberValue);
                      if (total < 0) total = 0;
                    }
                    amountcontroller.text = NumberFormatterHelper.decimalToString(total);
                    numbercontroller.text = '';
                    Navigator.pop(context);
                }
              }, 
              child: const Text('Ok')
              )
          ],
        );
      });
  }
}