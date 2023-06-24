import 'package:bstable/sql/sql_helper.dart';
import 'package:flutter/material.dart';

class DataModel {
  static List<Map<String, dynamic>> records = [];
  DataModel(records) {
    SQLHelper.getItems().then((rows) {
      records = rows;
    });
    print("data model");
  }
}
