import 'package:time_manager/common/data_utils.dart';

import '../data.dart';
import '../../common/data_access_layer/data_samples.dart';

abstract class Data {
  Future<bool> save<T>();
  T read<T>();
  bool update();
  bool delete();

  Future<int> sqlLiteInsert();
  Future<T> sqlLiteSelect<T>();
  Future<List<T>> sqlLiteSelectAll<T>();
  Future<int> sqlLiteUpdate();
  Future<int> sqlLiteDelete();
}

abstract class Options {
  String name;
  String description;

  Future<Iterable<String>> options();
}

abstract class DataHelper<T> {
  T createNew();
  Future<bool> create(T data);
  Future<T> read(int id);
  Future<bool> update(T data);
  Future<bool> delete(T data);

  Future<int> sqlLiteInsert(T data);
  Future<T> sqlLiteSelect(int id);
  Future<List<T>> sqlLiteSelectAll();
  Future<int> sqlLiteUpdate(T data);
  Future<int> sqlLiteDelete(int id);
}

class DT<T> {
  Future<bool> delete(T data){

  }
}


