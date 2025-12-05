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
    // If it's a full URL pointing to our storage, rewrite it to use the proxy
    if (contains('${Variables.baseUrl}/storage/')) {
      return replaceFirst('${Variables.baseUrl}/storage/', '${Variables.baseUrl}/storage-proxy/');
    }
    
    // If it's another external URL, return as is
    if (contains('http')) return this;
    
    // If it's a relative path, prepend the proxy base URL
    return '${Variables.baseUrl}/storage-proxy/$this';
  }
}
