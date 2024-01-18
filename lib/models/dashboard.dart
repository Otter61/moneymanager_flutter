class Dashboard {
  final String categoryName;
  final String? dateValue;
  final double amount;

  Dashboard({
    required this.categoryName,
    this.dateValue,
    required this.amount
  });

  static Dashboard toMap(Map<String, dynamic> map) {
    return Dashboard(
      categoryName: map['name'],
      dateValue: map['dateValue'],
      amount: map['amount']
      );
  }

  static Dashboard toMapMonthly(Map<String, dynamic> map) {
    return Dashboard(
      categoryName: map['name'],
      dateValue: map['dateValue'].toString().substring(5),
      amount: map['amount']
      );
  }
}