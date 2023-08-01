import 'package:bstable/sql/sql_helper.dart';
import 'package:flutter/material.dart';

class DataModel {
  static List<Map<String, dynamic>> records = [];
  DataModel(records) {
    SQLHelper.getAllActivities().then((rows) {
      records = rows;
    });
    print("data model");
  }
}
