import 'package:bstable/services/hot_restart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CurrencySerive {
  final _getStorage = GetStorage();
  final storageKey = "currency";

  String getSavedCureency() {
    var currency = _getStorage.read(storageKey);
    return currency ?? 'USD';
  }

  void saveCurrency(String currency) {
    _getStorage.write(storageKey, currency);
  }
}

class CurrencyController extends GetxController {
  RxString selectedCurrency =
      CurrencySerive().getSavedCureency().obs; // Default currency is USD
  static Map<String, String> currency_symbol = {
    'USD': '\$', // Dollar symbol
    'MRO': 'MRO', // Mauritanian Ouguiya
    'EUR': '€', // Euro symbol
    'TND': 'TND', // Tunisian Dinar
  };

  String get getSelectedCurrency {
    return currency_symbol[selectedCurrency]??"USD";
  }

  void changeCurrency(String newCurrency) {
    selectedCurrency.value = newCurrency;
    CurrencySerive().saveCurrency(newCurrency);
  }
}
