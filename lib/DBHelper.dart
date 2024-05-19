import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabases.db";
  static const _databaseVersion = 1;

  static const table = 'task_table';

  static const id = 'id';
  static const name = 'name';
  static const taskName = 'task_name';
  static const taskDisc = 'disc';
  static const dateTime = 'date_time';
  static const status = 'status';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $id INTEGER PRIMARY KEY,
          $name TEXT NOT NULL,
          $taskName TEXT NOT NULL,
          $taskDisc TEXT NOT NULL,
          $dateTime TEXT NOT NULL,
          $status TEXT NOT NULL
        )
        ''');
  }

  // Insert Data in Table
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  // Get All Data From Table
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // Get Pending Data From Table
  Future<List<Map<String, dynamic>>> queryPendingRows() async {
    return await _db.query(table, where: '$status = ?', whereArgs: ['pending']);
  }

  // Get Complete Data From Table
  Future<List<Map<String, dynamic>>> queryCompleteRows() async {
    return await _db
        .query(table, where: '$status = ?', whereArgs: ['complete']);
  }

  // Update status to 'complete' for a given ID
  Future<void> updateStatusComplete(int id) async {
    await _db.update(
      table,
      {status: 'complete'},
      where: '$id = ?',
      whereArgs: [id],
    );
  }

// Delete the table from the database
  // Future<void> deleteTable() async {
  //   await _db.execute('DROP TABLE IF EXISTS $table');
  // }
}
