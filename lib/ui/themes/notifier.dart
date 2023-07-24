import 'package:get/get.dart';

class ThemeChanger extends GetxController {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    print("hello");
    update(); // Notify all listeners about the theme change
  }
}
