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
  static List<String>? _createSqls;

  static init(String dbName, int version, List<String> createSqls) {
    _dbName = dbName;
    _version = version;
    _createSqls = createSqls;
  }

  static Future<Database> getDbAsync() async {
    if (_db != null) return _db!;

    // lazily instantiate the db the first time it is accessed
    //_database = await _initDatabase();
    //return _database;

    //case insensitive
    _db = await openDatabase(
      join(await getDatabasesPath(), _dbName!),
      version: _version!,
      onCreate: (db, version) {
        for (var sql in _createSqls!){
          db.execute(sql);
        }
      },    
    );

    return _db!;
  }

  /// insert
  static Future<bool> insertAsync(String table, Map<String, dynamic> map) async {
    //db.insert return row sn
    var db = await getDbAsync();
    var count = await db.insert(table, map,
      conflictAlgorithm: ConflictAlgorithm.fail
    );
    return (count == 1);
  }

  /// update
  static Future<bool> updateAsync(String table, Map<String, dynamic> map, 
    String where, List<Object> args) async {
      
    //db.update return rows affected
    var db = await getDbAsync();
    var count = await db.update(table, map,
        where: where,
        whereArgs: args,
        //conflictAlgorithm: ConflictAlgorithm.fail
    );
    return (count == 1);
  }

  /// delete
  static Future<bool> deleteAsync(String table, String where, List<Object> args) async {      
    //db.delete return rows affected
    var db = await getDbAsync();
    var count = await db.delete(table, 
        where: where,
        whereArgs: args,
    );
    return (count == 1);
  }

  //query below
  static Future<int> getCountAsync(String sql) async {
    var db = await getDbAsync();
    var count = Sqflite.firstIntValue(await db.rawQuery(sql));
    return count ?? 0;
  }

  static Future<Map<String, dynamic>?> getMapAsync(String sql, [List<dynamic>? args]) async {
    var db = await getDbAsync();
    var rows = await db.rawQuery(sql, (args == null || args.isEmpty) ? null : args);
    return (rows.isEmpty)
      ? null : rows[0];
  }

  static Future<List<Map<String, dynamic>>> getMapsAsync(String sql, [List<dynamic>? args]) async {
    var db = await getDbAsync();
    return await db.rawQuery(sql, (args == null || args.isEmpty) ? null : args);
  }

  static Future<List<IdStrDto>> getIdStrsAsync(String sql) async {
    var db = await getDbAsync();
    return JsonUt.rowsToIdStrs(await db.rawQuery(sql));
  }

  /// close db
  static Future closeAsync() async {
    if (_db != null) await _db!.close();
  }

} //class
