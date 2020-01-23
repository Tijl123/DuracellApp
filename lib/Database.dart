import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'LogModel.dart';
import 'SensorModel.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "LogDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Log(id INTEGER PRIMARY KEY, sensor TEXT, waarde TEXT, datum TEXT)");
      await db.execute("CREATE TABLE Sensor(id INTEGER PRIMARY KEY, sensor TEXT, isSubscribed INTEGER)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (1,'sensor1', 1)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (2,'sensor2', 1)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (3,'sensor3', 0)");
    });
  }

  Future<void> insertLog(LogModel log) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Log");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Log (id,sensor,waarde,datum)"
            " VALUES (?,?,?,?)",
        [id, log.sensor, log.waarde, log.datum]);
    return raw;
  }

  Future<void> insertSensor(SensorModel sensor) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Sensor");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Sensor (id,sensor, isSubscribed)"
            " VALUES (?,?,?)",
        [id, sensor.sensor, sensor.isSubscribed]);
    return raw;
  }

  updateSensor(SensorModel sensor) async {
    print('werkt!');
    final db = await database;
    var res = await db.update("Sensor", sensor.toMap(),
        where: "id = ?", whereArgs: [sensor.id]);
    return res;
  }

  Future<List<LogModel>> getAllLogs() async {
    final db = await database;
    var res = await db.query("Log");
    List<LogModel> list =
    res.isNotEmpty ? res.map((c) => LogModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SensorModel>> getAllSensors() async {
    final db = await database;
    var res = await db.query("Sensor");
    List<SensorModel> list =
    res.isNotEmpty ? res.map((c) => SensorModel.fromMap(c)).toList() : [];
    return list;
  }

  // A method that retrieves all the dogs from the dogs table.
  deleteLog(int id) async {
    final db = await database;
    return db.delete("Log", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Log");
  }
}

