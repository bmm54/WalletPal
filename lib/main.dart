import 'package:bstable/firebase_options.dart';
import 'package:bstable/onboarding.dart';
import 'package:bstable/services/currency.dart';
import 'package:bstable/services/transaction_service.dart';
import 'package:bstable/services/language_service.dart';
import 'package:bstable/translation/local.dart';
import 'package:bstable/ui/themes/dark.dart';
import 'package:bstable/ui/themes/light.dart';
import 'package:bstable/services/theme_service.dart';
import 'package:bstable/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    TransactionsService().startListeningForTransactions(currentUser.uid);
  }
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  MyApp({super.key, required this.showHome});
  final CurrencyController currencyController = Get.put(CurrencyController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        translations: LocalTranslation(),
        locale: Locale(LanguageService().getLanguage()),
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: ThemeService().getThemeMode(),
        debugShowCheckedModeBanner: true,
        home: this.showHome ? Wrapper() : OnBoardingPage());
  }
}
