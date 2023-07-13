import 'package:bstable/models/expense_model.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:intl/intl.dart';

class ExpenseData {
  static List<ExpenseItem> overAllExpenses = [];
  static Future<List<Map<String, dynamic>>> allExpenses() => SQLHelper.getExpenses();
  static String getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  //Start of the week
  DateTime startOfTheWeek() {
    DateTime today = DateTime.now();
    return today.subtract(Duration(days: today.weekday - 1));
  }

  //calculate daily expenses
  static Map<String, double> calculateDailyExpenses() {
    Map<String, double> dailyExpenses = {
      "Mon": 0,
      "Tue": 0,
      "Wed": 0,
      "Thu": 0,
      "Fri": 0,
      "Sat": 0,
      "Sun": 0,
    };
    allExpenses().then(
      (value) {
        for (var expense in value) {
          String title = expense['title'];
          String date = expense['date'];
          double amount = expense['amount'];
          DateTime dateTime = DateTime.parse(date);
          overAllExpenses.add(ExpenseItem(
              title: title, amount: amount, date: getDayOfWeek(dateTime)));
        }
      },
    );
    for (var expense in overAllExpenses) {
      String date = DateFormat('dd MM yyyy').format(DateTime.parse(expense.date));
      double amount = expense.amount;

      if (dailyExpenses.containsKey(date)) {
        dailyExpenses[date] = dailyExpenses[date]! + amount;
      } else {
        dailyExpenses[date] = amount;
      }
    }
    return dailyExpenses;
  }
}
