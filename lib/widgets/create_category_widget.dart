import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/category.dart';

class CreateCategoryWidget extends StatefulWidget {
  final Category? category;
  final ValueChanged<String> onSubmit;

  // final void Function(Category category) onSubmit;

  const CreateCategoryWidget({
    super.key,
    this.category,
    required this.onSubmit
  });

  @override
  State<StatefulWidget> createState() => _CreateCategoryWidgetState();
}

class _CreateCategoryWidgetState extends State<CreateCategoryWidget> {
  final namecontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    namecontroller.text = widget.category?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Category' : 'Add Category'),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          controller: namecontroller,
          decoration: const InputDecoration(hintText: 'Name'),
          validator: (value) => value != null && value.isEmpty ? 'Name is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('Cancel')
          ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.onSubmit(namecontroller.text);
            }
          }, 
          child: const Text('Ok')
          )
      ],
    );
  }
}