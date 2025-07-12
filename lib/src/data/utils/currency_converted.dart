import 'package:ipaconnect/src/data/utils/get_currency_code.dart';
import 'package:currency_converter/currency_converter.dart';

Future<double?> convertCurrency({
  required String from,
  required String to,
  required double amount,
}) async {

  try {
    final result = await CurrencyConverter.convert(
      from: getCurrencyFromCode(from),
      to: getCurrencyFromCode(to),
      amount: amount,
    );
    return result;
  } catch (e) {
    print('Conversion error: $e');
    return null;
  }
}

