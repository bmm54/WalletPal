import 'package:bstable/sql/sql_helper.dart';

class Accounts {
  static List<dynamic> accounts = [];
  static get getAccounts {
    SQLHelper.getAccounts().then((value) => accounts = value);
    return accounts;
  }
}
