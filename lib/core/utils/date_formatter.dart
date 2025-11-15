import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_addZeroPrefix(dateTime.month)}-${_addZeroPrefix(dateTime.day)}';
  }

  static String _addZeroPrefix(int value) {
    return value.toString().padLeft(2, '0');
  }

  static String formatDateTime2(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat(
      'dd MMMM yyyy, HH:mm',
    );
    return formatter.format(dateTime);
  }
}
