import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_manager/utils/logx.dart';

class DatabaseHelper {
  // 单例模式
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'time_manager.db');

    Database db = await openDatabase(dbPath, version: 1);
    return db;
  }

  Future<bool> isTableExists(Database db, String tableName) async {
    var count = Sqflite.firstIntValue(
      await db.rawQuery(
        "SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = ?",
        [tableName],
      ),
    );
    return count != 0;
  }

  // 创建表
  void createTables(String tableName, String sql) async {
    // 先判断表是否存在
    bool ok = await isTableExists(_database!, 'tasks');
    if (ok) {
      // 表存在就不创建
      return null;
    }
    await _database!.execute('''
      $sql
    ''');
    logx.infof("create table success: $tableName");
  }

  // 插入数据
  Future<void> insert(String name, int duration) async {
    Database db = await database;
    await db.insert('tasks', {
      'name': name,
      'duration': duration,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 查询数据
  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await database;
    List<Map<String, dynamic>> tasks = await db.query('tasks');
    return tasks;
  }

  // 更新数据
  Future<void> updateTask(int id, String name, int duration) async {
    Database db = await database;
    await db.update(
      'tasks',
      {'name': name, 'duration': duration},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 删除数据
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
