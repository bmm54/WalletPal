import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CurrencySerive {
  final _getStorage = GetStorage();
  final storageKey = "currency";

  String getCureency() {
    var currency = _getStorage.read(storageKey);
    return currency ?? 'USD';
  }

  void saveCurrency(String currency) {
    _getStorage.write(storageKey, currency);
  }
}

class CurrencyController extends GetxController {
  RxString selectedCurrency =
      CurrencySerive().getCureency().obs; // Default currency is USD

  void changeCurrency(String newCurrency) {
    selectedCurrency.value = newCurrency;
    CurrencySerive().saveCurrency(newCurrency);
  }
}
