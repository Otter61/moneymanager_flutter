import 'package:flutter/material.dart';
import 'package:moneymanager_app/models/category.dart';

import 'category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key, 
    required this.categories,
    required this.onTap,
    required this.onWallet
    });

  final List<Category> categories;
  final void Function(Category category) onTap;
  final void Function(Category category) onWallet;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (ctx, index) => InkWell(
        child: CategoryItem(categories[index],
        onWallet: onWallet,),
        onTap: () {
          onTap(categories[index]);
        },
      )
    );
  }
}