import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:intl/intl.dart';

extension StringExt on String {
  int get toIntegerFromText {
    final cleanedText = replaceAll(RegExp(r'[^0-9]'), '');
    final parsedValue = int.tryParse(cleanedText) ?? 0;
    return parsedValue;
  }

  String get currencyFormatRpV2 {
    final parsedValue = int.tryParse(this) ?? 0;
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(parsedValue);
  }

String get toImageUrl {
  final base = Variables.baseUrl;
  final storage = '$base/storage/';
  final proxy = '$base/storage-proxy/';

  // Full URL pointing to our storage → convert to proxy
  if (startsWith(storage)) {
    return replaceFirst(storage, proxy);
  }

  // Any external URL (http/https) → return as is
  if (startsWith('http://') || startsWith('https://')) {
    print('✅ External URL: $this');
    return this;
  }

  // Relative paths that start with storage/
  if (startsWith('storage/')) {
    return '$proxy${substring('storage/'.length)}';
  }

  // Relative paths that start with /storage/
  if (startsWith('/storage/')) {
    return '$proxy${substring('/storage/'.length)}';
  }

  // Any other relative path
  return '$proxy$this';
}

}
