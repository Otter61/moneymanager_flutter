import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class DateFormatterHelper {
  static final monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static String dateToString(DateTime date) {
    return formatter.format(date);
  }

  static DateTime stringToDate(String date) {
    return formatter.parse(date);
  }

  static String getMonthName(int num) {
    return monthNames[num - 1];
  }
}