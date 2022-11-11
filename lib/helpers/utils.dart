import 'package:intl/intl.dart';

NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

extension StringParsing on String {
  /// converte string para double
  double toDouble() {
    if (isEmpty) return 0.0;
    String num = '';
    if (contains(',')) {
      num = replaceAll(RegExp('[^0-9,-]'), '').replaceAll(',', '.');
    } else {
      num = replaceAll(RegExp('[^0-9.-]'), '');
    }
    try {
      return double.parse(num);
    } catch (e) {
      return 0.0;
    }
  }

  String toReal() {
    var num = replaceAll(RegExp(r'^D'), '');
    return formatter.format(double.parse(num));
  }
}
