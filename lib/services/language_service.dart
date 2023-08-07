import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  final _getStorage = GetStorage();
  final storageKey = "language";

  getLanguage() {
    var language = _getStorage.read(storageKey);
    return language??'en';
  }

  void saveLanguage(String language) {
    _getStorage.write(storageKey, language);
  }
}
