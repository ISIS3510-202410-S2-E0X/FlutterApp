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
    String path = join(documentsDirectory.path, "RDsLS_4.db");
    print("DB path: $path");
    return await openDatabase(path, version: 1, onCreate: _createDB);
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
}
