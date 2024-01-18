class Wallet {
  final int categoryId;
  final String name;
  final double budgetTotal;
  final double expenseTotal;
  final double balanceTotal;

  Wallet({
    required this.categoryId,
    required this.name,
    required this.budgetTotal,
    required this.expenseTotal
  }) : balanceTotal = (budgetTotal - expenseTotal);
}