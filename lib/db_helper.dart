import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'boleh1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        level TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ticket_stocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        namaTiket TEXT NOT NULL,
        jumlah INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kodeTransaksi TEXT NOT NULL,
        email TEXT NOT NULL,
        namaTiket TEXT NOT NULL,
        date TEXT NOT NULL,
        amount INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE printed_tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kodeTiket TEXT NOT NULL,
        namaTiket TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await db.execute('''
          CREATE TABLE movies(
            id INTEGER PRIMARY KEY,
            name TEXT,
            rating REAL
          )
        ''');
    await db.execute('''
          CREATE TABLE ratings(
            id INTEGER PRIMARY KEY,
            movieId INTEGER,
            user TEXT,
            rating INTEGER,
            FOREIGN KEY(movieId) REFERENCES movies(id)
          )
        ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> update(String table, Map<String, dynamic> data,
      String whereClause, List whereArgs) async {
    final db = await database;
    return await db.update(table, data,
        where: whereClause, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String whereClause, List whereArgs) async {
    final db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> query(
      String table, String whereClause, List whereArgs) async {
    final db = await database;
    return await db.query(table, where: whereClause, whereArgs: whereArgs);
  }
}
