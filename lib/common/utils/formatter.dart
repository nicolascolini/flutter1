import 'package:intl/intl.dart';

abstract class Formatter {
  /// Format a number as Brazilian currency (e.g., R$ 1.234,56)
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(amount);
  }

  /// Format a DateTime as a full date in Brazilian Portuguese
  /// Format: dd 'de' MMMM 'de' y (e.g., 01 de janeiro de 2023)
  static String formatDate(DateTime date) {
    return DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(date);
  }

  /// Format a DateTime as a compact Brazilian date
  /// Format: dd/MM/yyyy (e.g., 01/01/2023)
  static String formatCompactDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  /// Format a DateTime for charts in Brazilian format
  /// Format: dd/MM (e.g., 01/01)
  static String formatChartDate(DateTime date) {
    return DateFormat('dd/MM', 'pt_BR').format(date);
  }

  /// Format a DateTime as Brazilian time
  /// Format: HH:mm (e.g., 14:30)
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm', 'pt_BR').format(time);
  }
}
