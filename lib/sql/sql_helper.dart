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
      image_url TEXT
      )''');
    await database.execute('''CREATE TABLE accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT UNIQUE NOT NULL CHECK(name != ''),
      balance REAL default 0.0,
      color TEXT)''');
    await database.execute('''CREATE TABLE Goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT NOT NULL CHECK(name != ''),
      amount REAL default 0.0,
      goal REAL NOT NULL,
      icon_name TEXT,
      color TEXT)''');
    await database.execute('''CREATE TABLE Transactions (
      uid TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL,
      owe REAL default 0.0,
      owe_to REAL default 0.0,
      image_url TEXT
      )''');
  }

  static Future<sql.Database> db() async {
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
      'amount': amount,
    };
    final id = await db.insert(
        'activities', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
    return id;
  }

  static Future<int> insertTransaction(String title, String category,
      double amount, String status, String time, imageUrl) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'time': time,
      'category': category,
      'amount': amount,
      'status': status,
      'image_url': imageUrl
    };
    final id = await db.insert(
        'activities', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
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
    return id;
  }

  static Future<int> createTransactionContact(
      String uid, String name, String? imageUrl) async {
    final db = await SQLHelper.db();
    final data = {'uid': uid, 'name': name, 'image_url': imageUrl};
    final id = await db.insert(
        'transactions', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
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
  }

  static Future<void> addToGoal(double amount, int id) async {
    final db = await SQLHelper.db();
    db.rawUpdate("UPDATE goals SET amount=amount+$amount WHERE id=$id");
  }

  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from activities order by time desc");
  }

  static Future<List<Map<String, dynamic>>> getPersonsTransactions() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * FROM Transactions");
  }

  static Future<List<Map<String, dynamic>>> getTransactionContact(
      String uid) async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * FROM Transactions WHERE uid = '$uid'");
  }

  static Future<bool> contactExists(String uid) async {
    final db = await SQLHelper.db();
    final result =
        await db.rawQuery("SELECT * FROM transactions WHERE uid = ?", [uid]);
    return result.isNotEmpty;
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
  }

  static Future<void> deleteAllAccount() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM accounts");
  }

  static Future<void> deleteAccount(id) async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM accounts WHERE id=$id");
  }

  static Future<void> deleteGoal(id) async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM Goals WHERE id=$id");
  }

  static Future<void> deleteAllActivities() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM activities");
    db.rawDelete("DELETE FROM goals");
  }

  static Future<void> deleteAllTransactionsContacts() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM Transactions");
  }

  static Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "Select amount,title,time from activities where category='expense'");
  }

  static Future<List<Map<String, dynamic>>> getIcomes() async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "Select amount,title,time from activities where category='income'");
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
  }

  static Future<void> updateGoal(
      int id, String name, double amount, double goal, String color) async {
    final db = await SQLHelper.db();
    await db.rawUpdate(
        "UPDATE goals SET name=?, amount=?, goal=?, color=? WHERE id=?",
        [name, amount, goal, color, id]);
  }

  static Future<void> updateAccount(
      int id, String name, double balance, String color) async {
    final db = await SQLHelper.db();
    await db.rawUpdate(
        "UPDATE accounts SET name=?, balance=?, color=? WHERE id=?",
        [name, balance,color, id]);
  }
  static Future<void> updateTransactionContact(
      double amount, String type, String status, String uid) async {
    final db = await SQLHelper.db();

    // Ensure that the amount is positive
    if (amount <= 0) {
      throw ArgumentError("Amount must be a positive value.");
    }

    if (type == "Sent") {
      if (status == "Loan") {
        //loan to
        db.rawUpdate(
            "UPDATE Transactions SET owe = CASE WHEN (owe + $amount) < 0 THEN 0 ELSE (owe + $amount) END WHERE uid = '$uid'");
      }
      //paycheck
      else {
        db.rawUpdate(
            "UPDATE Transactions SET owe_to = CASE WHEN (owe_to - $amount) < 0 THEN 0 ELSE (owe_to - $amount) END WHERE uid = '$uid'");
      }
      //received
    } else {
      //loan to you
      if (status == "Loan") {
        db.rawUpdate(
            "UPDATE Transactions SET owe_to = CASE WHEN (owe_to + $amount) < 0 THEN 0 ELSE (owe_to + $amount) END WHERE uid = '$uid'");
      }
      //paycheck
      else {
        db.rawUpdate(
            "UPDATE Transactions SET owe = CASE WHEN (owe - $amount) < 0 THEN 0 ELSE (owe - $amount) END WHERE uid = '$uid'");
      }
    }
  }
}
