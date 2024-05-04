import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class dbhelper {
  Future<Database> setDatabase() async {
    Directory a = await getApplicationDocumentsDirectory();
    String path = join(a.path, 'task');
    return await openDatabase(path, version: 1, onCreate: createdb);
  }

  Future<void> createdb(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE task(id INTEGER PRIMARY KEY,title TEXT,description TEXT,status TEXT DEFAULT 'no' )");
  }
}

class repo {
  late dbhelper s;

  repo() {
    s = dbhelper();
  }
  static Database? db;
  Future<Database?> initiatedb() async {
    if (db == null) {
      db = await s.setDatabase();
    }
    return db;
  }

  inserdata(table, data) async {
    var conn = await initiatedb();
    return await conn?.insert(table, data);
  }

  selectdata(table, condtion) async {
    var conn = await initiatedb();
    return await conn?.query(table, where: "status=?", whereArgs: [condtion]);
  }

  selectonedata(table, id) async {
    var conn = await initiatedb();
    return await conn?.query(table, where: "id=?", whereArgs: [id]);
  }

  deletedata(table, id) async {
    var conn = await initiatedb();
    return await conn?.rawDelete("DELETE FROM $table WHERE id=$id");
  }

  updatedata(table, data) async {
    var conn = await initiatedb();
    return await conn
        ?.update(table, data, where: "id=?", whereArgs: [data['id']]);
  }

  getcount(table) async {
    var conn = await initiatedb();
    var a = await conn?.rawQuery("SELECT count(*) FROM $table");
    return Sqflite.firstIntValue(a!);
  }
}
