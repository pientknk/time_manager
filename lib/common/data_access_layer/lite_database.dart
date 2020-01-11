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

  Future<Map<String, dynamic>> sqlLiteBaseSelect2<T>(Type objectType, String whereCondition, List<dynamic> whereArgs) async {
    final db = await liteDB.dataBase;
    var result = await db.query(objectType.toString(), where: whereCondition, whereArgs: whereArgs);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<T>> sqlLiteBaseSelectAll<T>(Function mapFunction, Type objectType) async {
    final db = await liteDB.dataBase;
    var result = await db.query(objectType.toString());
    List<T> resultList =
      result.isNotEmpty ? result.map((t) => mapFunction(t)).toList() : [];

    return resultList;
  }

  Future<List<Map<String, dynamic>>> sqlLiteBaseSelectAll2<T>(Type objectType) async {
    final db = await liteDB.dataBase;
    var result = await db.query(objectType.toString());

    return result.isNotEmpty ? result : [];
  }

  Future<int> sqlLiteBaseUpdate<T>(Type objectType, Map<String, dynamic> json) async {
    final db = await liteDB.dataBase;
    int id = int.parse(json['id']);
    int result = await db.update(objectType.toString(), json, where: "id = ?", whereArgs: [id]);

    return result;
  }

  Future<int> sqlLiteBaseDelete<T>(Type objectType, int idValue) async {
    final db = await liteDB.dataBase;
    Future<int> result = db.delete(objectType.toString(), where: "id = ?", whereArgs: [idValue]);

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