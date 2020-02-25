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

  //Database word geinitialiseerd
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "LogDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Log(id INTEGER PRIMARY KEY, sensor TEXT, waarde TEXT, datum TEXT, isConfirmed INTEGER)");
      await db.execute("CREATE TABLE Sensor(id INTEGER PRIMARY KEY, sensor TEXT, isSubscribed INTEGER)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (1,'sensor1', 1)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (2,'sensor2', 1)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (3,'sensor3', 0)");
      await db.rawInsert("INSERT Into Sensor (id,sensor, isSubscribed) VALUES (4,'sensor4', 0)");
    });
  }

  //Methode om een log toe te voegen
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

  //Methode om een sensor toe te voegen
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

  //Methode om sensor te wijzigen
  updateSensor(SensorModel sensor) async {
    final db = await database;
    var res = await db.update("Sensor", sensor.toMap(),
        where: "id = ?", whereArgs: [sensor.id]);
    return res;
  }

  //Methode om log te wijzigen
  updateLog(LogModel log) async {
    final db = await database;
    var res = await db.update("Log", log.toMap(),
        where: "id = ?", whereArgs: [log.id]);
    return res;
  }

  //Lijst van alle logs opvragen
  Future<List<LogModel>> getAllLogs() async {
    final db = await database;
    var res = await db.query("Log");
    List<LogModel> list =
    res.isNotEmpty ? res.map((c) => LogModel.fromMap(c)).toList() : [];
    return list;
  }

  //Lijst van alle logs gesorteerd op datum
  Future<List<LogModel>> getAllLogsOrderByDate() async {
    final db = await database;
    var res = await db.query("Log", orderBy: "id DESC");
    List<LogModel> list =
    res.isNotEmpty ? res.map((c) => LogModel.fromMap(c)).toList() : [];
    return list;
  }

  //Lijst van alle sensors
  Future<List<SensorModel>> getAllSensors() async {
    final db = await database;
    var res = await db.query("Sensor");
    List<SensorModel> list =
    res.isNotEmpty ? res.map((c) => SensorModel.fromMap(c)).toList() : [];
    return list;
  }

  //Een bepaalde log verwijderen
  deleteLog(int id) async {
    final db = await database;
    return db.delete("Log", where: "id = ?", whereArgs: [id]);
  }

  //Alle logs verwijderen
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Log");
  }
}

