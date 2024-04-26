import 'package:path/path.dart';
import 'package:sciflare/src/model/user_model.dart';
import 'package:sciflare/src/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "sciflare_bala.db");
    var theDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableUser ( 
          $columnId integer, 
          $columnName text not null,
          $columnPhone text not null,
          $columnGender text not null,
          $columnEmail email not null)
          ''');
    });
    return theDb;
  }

  DatabaseHelper.internal();

  Future<UserModel> insert(UserModel user) async {
    var dbClient = await db;
    user.id = await dbClient!.insert(tableUser, user.toMap());
    return user;
  }

  /*  Future<UserModel> getUser(int id) async {
    var dbClient = await db;
    List<Map<String,dynamic>> maps = await dbClient!.query(tableUser,
        columns: [columnId, columnName, columnPhone, columnEmail],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return UserModel();
  } */

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> user = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query(tableUser,
        columns: [
          columnId,
          columnName,
          columnPhone,
          columnGender,
          columnEmail
        ]);
    if (maps.isNotEmpty) {
      for (var f in maps) {
        user.add(UserModel.fromMap(f));
//          print("getAllUsers"+ User.fromMap(f).toString());
      }
    }
    return user;
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

  Future clearAllRecord() async {
    var dbClient = await db;
    dbClient!.delete(tableUser);
  }
}
