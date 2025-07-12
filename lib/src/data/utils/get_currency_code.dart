import 'package:currency_converter/currency.dart';

Currency getCurrencyFromCode(String code) =>
    Currency.values.firstWhere((c) => c.name.toUpperCase() == code.toUpperCase());
