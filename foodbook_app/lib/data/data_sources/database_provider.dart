import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseProvider {
  static Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "LoSgDraftsDB_5.db");
    print("DB path: $path");
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await _createDB(db, version);
      await _createSecondTable(db, version);
      await _createThirdTable(db, version);
    });
  }

  _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ReviewDrafts ("
        "user TEXT,"
        "spot TEXT,"
        "title TEXT,"
        "content TEXT,"
        "image TEXT,"
        "uploaded INTEGER,"
        "cleanliness INTEGER,"
        "service INTEGER,"
        "foodQuality INTEGER,"
        "waitTime INTEGER,"
        "category1 TEXT,"
        "category2 TEXT,"
        "category3 TEXT"
        ")"
      );
  }

   _createSecondTable(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ToUpload ("
        "user TEXT,"
        "spot TEXT,"
        "title TEXT,"
        "content TEXT,"
        "image TEXT,"
        "uploaded INTEGER,"
        "cleanliness INTEGER,"
        "service INTEGER,"
        "foodQuality INTEGER,"
        "waitTime INTEGER,"
        "category1 TEXT,"
        "category2 TEXT,"
        "category3 TEXT"
        ")"
      );
  }

   _createThirdTable(Database db, int version) async {
    await db.execute(
        "CREATE TABLE BugsReports ("
        "description TEXT,"
        "bugType TEXT,"
        "severityLevel TEXT,"
        "stepsToReproduce TEXT"
        ")"
      );
  }

  Future<void> clearTable(String tableName) async {
    final db = await getDatabase();
    await db.execute('DELETE FROM $tableName');
    print("All data from $tableName has been deleted.");
  }

  Future<void> killDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "LoSgDraftsDB_1.db");
    await deleteDatabase(path);
    _database = null;
    print("Database deleted successfully.");
  }
}