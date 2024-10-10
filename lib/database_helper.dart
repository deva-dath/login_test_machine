import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_session.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE session (id INTEGER PRIMARY KEY, username TEXT, password TEXT)');
      },
    );
  }

  Future<void> saveSession(String username, String password) async {
    final db = await database;

    await db.insert(
      'session',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getSession() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query('session');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }
}
