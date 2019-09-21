import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart";
import 'dart:io';

class LiteDBProvider {
  LiteDBProvider._();
  static final LiteDBProvider liteDB = LiteDBProvider._();

  static Database _dataBase;

  Future<Database> get dataBase async {
    if(_dataBase != null){
      return _dataBase;
    }else{
      _dataBase = await initLiteDB();
      return _dataBase;
    }
  }

  Future<int> sqlLiteBaseInsert<T>(Type objectType, Map<String, dynamic> json) async {
    final db = await liteDB.dataBase;
    int result = await db.insert(objectType.toString(), json);

    return result;
  }

  Future<T> sqlLiteBaseSelect<T>(Function mapFunction, Type objectType, String whereCondition, List<dynamic> whereArgs) async {
    final db = await liteDB.dataBase;
    var result = await db.query(objectType.toString(), where: whereCondition, whereArgs: whereArgs);
    return result.isNotEmpty ? mapFunction(result.first) : null;
  }

  Future<List<T>> sqlLiteBaseSelectAll<T>(Function mapFunction, Type objectType) async {
    final db = await liteDB.dataBase;
    var result = await db.query(objectType.toString());
    List<T> resultList =
      result.isNotEmpty ? result.map((t) => mapFunction(t)).toList() : [];

    return resultList;
  }

  Future<int> sqlLiteBaseUpdate<T>(Type objectType, Map<String, dynamic> json, int idValue, String primaryKeyName) async {
    final db = await liteDB.dataBase;
    int result = await db.update(objectType.toString(), json, where: "$primaryKeyName = ?", whereArgs: [idValue]);

    return result;
  }

  Future<int> sqlLiteBaseDelete<T>(Type objectType, int idValue, String primaryKeyName) async {
    final db = await liteDB.dataBase;
    Future<int> result = db.delete(objectType.toString(), where: "$primaryKeyName = ?", whereArgs: [idValue]);

    return result;
  }

  initLiteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TimeKeeperDB.db");

    return await openDatabase(path,
      version: 1,
      onOpen: (db) {

      },
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Project ("
          "id INTEGER IDENTITY(1,1) PRIMARY KEY,"
          "name TEXT,"
          "details TEXT"
          ")");
      }
    );
  }
}