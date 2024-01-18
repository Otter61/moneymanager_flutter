import 'package:intl/intl.dart';

final formatter = NumberFormat.decimalPatternDigits(locale: 'en_Us', decimalDigits: 2);

class NumberFormatterHelper {
  static String decimalToString(double? value) {
    if (value == null) return '';
    return formatter.format(value);
  }

  static double? stringToDecimal(String? value) {
    if (value == null) return null;
    if (double.tryParse(value.replaceAll(',', '')) == null) return null;
    return double.parse(value.replaceAll(',', ''));
  }
}