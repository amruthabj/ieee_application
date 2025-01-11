import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static const _databaseName = 'userDatabase.db';
  static const _databaseVersion = 1;

  static const table = 'users';
  static const columnId = 'id';
  static const columnEmail = 'email';
  static const columnPassword = 'password';

  // Make this a singleton class
  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper instance = UserDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEmail TEXT NOT NULL,
        $columnPassword TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    var result = await db.query(table, where: '$columnEmail = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }
}
