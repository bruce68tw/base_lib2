import 'package:collection/collection.dart';  //need !!
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/id_str_dto.dart';
import 'json_ut.dart';

/// static class
class DbUt {
  //static Database _db = await initDbAsync() as Database;
  static Database? _db;  // = initDbAsync() as Database;
  static int? _version;
  static String? _dbName;
  static List<String> _createSqls = [];

  static init(String dbName, int version, List<String> createSqls) {
    _dbName = dbName;
    _version = version;
    _createSqls = createSqls;
  }

  static Future<Database> getDbA() async {
    if (_db != null) return _db!;

    // lazily instantiate the db the first time it is accessed
    //_database = await _initDatabase();
    //return _database;

    //case insensitive
    _db = await openDatabase(
      join(await getDatabasesPath(), _dbName!),
      version: _version!,
      onCreate: (db, version) {
        for (var sql in _createSqls){
          db.execute(sql);
        }
      },    
    );

    return _db!;
  }

  // re-create table 
  static Future<void> reTableA(String table) async {
    //drop table
    var db = await getDbA();
    await db.execute("Drop Table if exists $table");

    //create table
    var sql = _createSqls.firstWhereOrNull((a) => a.contains(' $table'));
    if (sql != null) {
      await db.execute(sql);
    }
  }

  /// insert
  static Future<bool> insertA(String table, Map<String, dynamic> map) async {
    //db.insert return row sn
    var db = await getDbA();
    var count = await db.insert(table, map,
      conflictAlgorithm: ConflictAlgorithm.fail
    );
    return (count > 0);
  }

  /// update
  static Future<bool> updateA(String table, Map<String, dynamic> map, 
    String where, List<Object> args) async {
      
    //db.update return rows affected
    var db = await getDbA();
    var count = await db.update(table, map,
        where: where,
        whereArgs: args,
        //conflictAlgorithm: ConflictAlgorithm.fail
    );
    return (count == 1);
  }

  /// delete one/many rows
  static Future<int> deleteA(String table, String where, [List<Object>? args]) async {      
    //db.delete return rows affected
    var db = await getDbA();
    return await db.delete(table, where: where, whereArgs: args);
  }

  //query below
  static Future<int> getCountA(String sql) async {
    var db = await getDbA();
    var count = Sqflite.firstIntValue(await db.rawQuery(sql));
    return count ?? 0;
  }

  static Future<Map<String, dynamic>?> getJsonA(String sql, [List<dynamic>? args]) async {
    var db = await getDbA();
    var rows = await db.rawQuery(sql, (args == null || args.isEmpty) ? null : args);
    return (rows.isEmpty)
      ? null : rows[0];
  }

  static Future<List<Map<String, dynamic>>> getJsonsA(String sql, [List<dynamic>? args]) async {
    var db = await getDbA();
    return await db.rawQuery(sql, (args == null || args.isEmpty) ? null : args);
  }

  static Future<List<IdStrDto>> getIdStrsA(String sql) async {
    var db = await getDbA();
    return JsonUt.rowsToIdStrs(await db.rawQuery(sql));
  }

  /// close db
  static Future closeA() async {
    if (_db != null) await _db!.close();
  }

} //class
