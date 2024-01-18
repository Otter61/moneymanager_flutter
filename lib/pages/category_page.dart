import 'package:flutter/material.dart';
import 'package:moneymanager_app/helpers/category_db.dart';
import 'package:moneymanager_app/models/category.dart';
import 'package:moneymanager_app/screens/wallet_details_screen.dart';
import 'package:moneymanager_app/widgets/category_list.dart';
import 'package:moneymanager_app/widgets/create_category_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{
  Future<List<Category>>? categories;
  final categoryDB = CategoryDB();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }
  
  void fetchCategories() {
    setState(() {
      categories = categoryDB.getItems();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            final categoryData = snapshot.data!;

            return categoryData.isEmpty
              ? const Center(
                child: Text('No Categories...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: CategoryList(
                      categories: categoryData,
                      onWallet: (category) async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => WalletDetailsScreen(category: category)
                            )
                          );
                      }, 
                      onTap: (category) async {
                        showDialog(
                          context: context, 
                          builder: (_) => CreateCategoryWidget(
                            category: category,
                            onSubmit: (name) async {
                              await categoryDB.updateItem(id: category.id, name: name);
                              if(!mounted) return;
                              fetchCategories();
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
            builder: (_) => CreateCategoryWidget(
              onSubmit: (name) async {
                await categoryDB.createItem(name: name);
                if(!mounted) return;
                fetchCategories();
                Navigator.of(context).pop();
              },
            )
            );
        },
      ),
    );
  } 
}