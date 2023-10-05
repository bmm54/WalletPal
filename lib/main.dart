import 'package:bstable/firebase_options.dart';
import 'package:bstable/services/auth_data.dart';
import 'package:bstable/services/currency.dart';
import 'package:bstable/services/hot_restart.dart';
import 'package:bstable/services/transaction_service.dart';
import 'package:bstable/sql/sql_helper.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(new HotRestartController(child: new MyApp()));
}

class MyApp extends StatelessWidget {
  final CurrencyController currencyController = Get.put(CurrencyController());
  @override
  Widget build(BuildContext context) {
    //SQLHelper.deleteAllActivities();
    //SQLHelper.deleteAllAccount();
    //if authenticated start listening
    final currentUser = FirebaseAuth.instance.currentUser;
    if ( currentUser!= null) {
      TransactionsService.startListeningForTransactions(currentUser.uid);
    }
    return SafeArea(
      child: GetMaterialApp(
        translations: LocalTranslation(),
        locale: Locale(LanguageService().getLanguage()),
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: ThemeService().getThemeMode(),
        debugShowCheckedModeBanner: true,
        home: Wrapper(),
      ),
    );
  }
}
