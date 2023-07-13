import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE activity3 (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      time TEXT,
      category TEXT,
      amount REAL)''');
    await database.execute('''CREATE TABLE account1 (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      balance REAL,
      color TEXT)''');
    print(".......table created........");
  }

  static Future<sql.Database> db() async {
    print(".....database instance.............");
    return sql.openDatabase('my_db1.db', version: 3,
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
        'activity3', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
    print("activity created");
    return id;
  }

  static Future<int> insertAccount(
      String name, double balance, String color) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'balance': balance, 'color': color};
    final id = await db.insert(
        'account1', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it already exist replace it
        );
    print("account created");
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from Activity3 order by time desc");
  }

  static Future<List<Map<String, dynamic>>> queryAccounts() async {
    final db = await SQLHelper.db();
    return db.rawQuery('SELECT strftime("%Y-%m-%d", time) AS date, MAX(balance) AS high, MIN(balance) AS low '
        'FROM accounts WHERE id = ? GROUP BY date ORDER BY date');
  }

  static Future<void> dropTable(String tablename) async {
    final db = await SQLHelper.db();
    db.rawQuery("DROP TABLE $tablename");
    print("........table droped.......");
  }

  static Future<void> deleteAllAccount() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM account1");
    print(".....deleted......");
  }
    static Future<void> deleteAllActivities() async {
    final db = await SQLHelper.db();
    db.rawDelete("DELETE FROM activity3");
    print(".....deleted......");
  }

    static Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await SQLHelper.db();
    return db.rawQuery("Select sum(amount) as total,title from activity3 where category='expense' group by title");
  }

    static Future<List<Map<String, dynamic>>> getDebt() async {
    final db = await SQLHelper.db();
    return db.rawQuery("Select sum(amount) as total from activity3 where title='Loan' and category='expense'");
  }
  static Future<List<Map<String, dynamic>>> getIcomes() async {
    final db = await SQLHelper.db();
    return db.rawQuery("Select sum(amount) as total,title from activity3 where category='income' group by title");
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT * from account1 order by id desc");
  }

  static Future<List<Map<String, dynamic>>> getTotalBalance() async {
    final db = await SQLHelper.db();
    return db.rawQuery("SELECT sum(balance) as total from account1");
  }

  static Future<void> updateBalance(double amount, String type,int id) async {
    final db = await SQLHelper.db();
    type == "expense"
        ? db.rawUpdate("UPDATE account1 SET balance=balance-$amount WHERE id=$id")
        : db.rawUpdate("UPDATE account1 SET balance=balance+$amount WHERE id=$id");
    print(".............balance updated............");
  }
}



































/*
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('my_db.db', //db name or path of the db
        version: 1, 
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createItem(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert(
        'items', //table name
        data, //data
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace //if it aready exist replace it
        );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }
}*/
