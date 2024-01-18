import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:moneymanager_app/helpers/date_formatter_helper.dart';
import 'package:moneymanager_app/helpers/number_formatter_helper.dart';
import '../models/budget.dart';
typedef SubmitCallback = Future<void> Function(String name, double amount, DateTime selectedDate);

class CreateBudgetWidget extends StatefulWidget {
  final Budget? budget;
  final List<String> walletNames;
  final String selectedWallet;
  final SubmitCallback onSubmit;

  const CreateBudgetWidget({
    super.key,
    this.budget,
    required this.walletNames,
    required this.selectedWallet,
    required this.onSubmit
  });

  @override
  State<StatefulWidget> createState() => _CreateBudgetWidgetState();
}

class _CreateBudgetWidgetState extends State<CreateBudgetWidget> {
  final namecontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final numbercontroller = TextEditingController();
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

  Future<List<String>> getSuggestion(String pattern) async => Future<List<String>>.delayed(
    const Duration(milliseconds: 300),
    () => widget.walletNames.where((suggestion) => suggestion.toLowerCase().contains(pattern.toLowerCase())).toList()
  );

  @override
  void initState() {
    super.initState();
    if (widget.selectedWallet != '' && widget.budget == null) 
    {
      namecontroller.text = widget.selectedWallet;
    }
    else 
    {
      namecontroller.text = widget.budget?.name ?? '';
    }
    _selectedDate = widget.budget?.createdAt == null ? _selectedDate : DateFormatterHelper.stringToDate(widget.budget!.createdAt);
    amountcontroller.text = NumberFormatterHelper.decimalToString(widget.budget?.amount);
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;
    return SingleChildScrollView(
      reverse: true,
      child: AlertDialog(
        title: Text(isEditing ? 'Edit budget' : 'Add budget'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadField<String>(
                controller: namecontroller,
                builder:(context, controller, focusNode) {
                  return TextFormField(
                    controller: namecontroller,
                    focusNode: focusNode,
                    autofocus: !isEditing,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  );
                },
                itemBuilder: (context, item) {
                  return ListTile(title: Text(item));
                }, 
                onSelected: (suggestion) {
                  namecontroller.text = suggestion;
                }, 
                suggestionsCallback: getSuggestion,
                hideOnEmpty: true,
                hideOnSelect: true,
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
                          if (NumberFormatterHelper.stringToDecimal(value) == null) {
                            return 'Invalid amount';
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
                widget.onSubmit(namecontroller.text, NumberFormatterHelper.stringToDecimal(amountcontroller.text)!, _selectedDate);
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
