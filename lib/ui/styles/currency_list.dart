import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';

class CurrencyList {
  static Map<String, String> currencies = {
    'USD': '\$', // Dollar symbol
    'MRO': 'MRO', // Mauritanian Ouguiya
    'EUR': '€', // Euro symbol
    'TND': 'TND', // Tunisian Dinar
  };
  static get_symbol(String name) {
    return currencies[name];
  }
}
