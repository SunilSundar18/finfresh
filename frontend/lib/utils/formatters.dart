import 'package:intl/intl.dart';

class Formatters {
  // Formats numbers to Indian Rupee (e.g., 50000 -> ₹50,000)
  static String toRupee(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Safely converts any API value (String, null, int) to a double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}