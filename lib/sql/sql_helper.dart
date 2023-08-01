import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE activities (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      time TEXT,
      category TEXT,
      amount REAL,
      status TEXT,
      image_url TEXT,
      account_id INTEGER
      )''');
    await database.execute('''CREATE TABLE accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT UNIQUE NOT NULL,
      balance REAL default 0.0,
      color TEXT)''');
    await database.execute('''CREATE TABLE Goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT NOT NULL,
      amount REAL default 0.0,
      goal REAL NOT NULL,
      icon_name TEXT,
      color TEXT)''');
    print(".......table created........");
  }

  static Future<sql.Database> db() async {
    print(".....database instance.............");
    return sql.openDatabase('database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> insertActivity(
      String title, String category, double amount) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'time': DateTime.now().toString(),
      'category': category,
      'amount': amount
    };
    final id = await db.insert(
        'activities', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
    print("activity created");
    return id;
  }

  static Future<int> createAccount(
      String name, double balance, String color) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'balance': balance, 'color': color};
    final id = await db.insert(
        'accounts', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
    print("account created");
    return id;
  }

  static Future<void> createGoal(
      String name, double amount, double goal, String color) async {
    final db = await SQLHelper.db();

    final data = {'name': name, 'amount': amount, 'goal': goal, 'color': color};
      await db.insert(
          'goals', //table name
          data, //data
          conflictAlgorithm:
              sql.ConflictAlgorithm.replace //if it already exist replace it
          );
      print("goal created");
  }

    static Future<void> addToGoal(double amount,int id) async {
    final db = await SQLHelper.db();
    db.rawUpdate(
            "UPDATE goals SET amount=amount+$amount WHERE id=$id");
            }

  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from activities order by time desc");
  }

  static Future<List<Map<String, dynamic>>> getGoals() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from goals order by id desc");
  }

  static Future<List<Map<String, dynamic>>> queryAccounts() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        'SELECT strftime("%Y-%m-%d", time) AS date, MAX(balance) AS high, MIN(balance) AS low '
        'FROM accounts WHERE id = ? GROUP BY date ORDER BY date');
  }

  static Future<void> dropTable(String tablename) async {
    final db = await SQLHelper.db();
    db.rawQuery("DROP TABLE $tablename");
    print("........table droped.......");
  }

  static Future<void> deleteAllAccount() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM accounts");
    print(".....deleted......");
  }

  static Future<void> deleteAccount(id) async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM accounts WHERE id=$id");
    print(".....deleted......");
  }

  static Future<void> deleteAllActivities() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM activities");
    print(".....deleted......");
  }

  static Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "Select sum(amount) as total,title from activities where category='expense' group by title");
  }

  static Future<List<Map<String, dynamic>>> getDebt() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "Select sum(amount) as total from activities where title='Loan' and category='expense'");
  }

  static Future<List<Map<String, dynamic>>> getIcomes() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "Select sum(amount) as total,title from activities where category='income' group by title");
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from accounts order by id desc");
  }

  static Future<List<Map<String, dynamic>>> getTotalBalance() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT sum(balance) as total from accounts");
  }

  static Future<void> updateBalance(double amount, String type, int id) async {
    final db = await SQLHelper.db();
    type == "expense"
        ? db.rawUpdate(
            "UPDATE accounts SET balance=balance-$amount WHERE id=$id")
        : db.rawUpdate(
            "UPDATE accounts SET balance=balance+$amount WHERE id=$id");
    print(".............balance updated............");
  }
}
