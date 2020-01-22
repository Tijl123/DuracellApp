import 'package:duracellapp/LogModel.dart';
import 'package:sqflite/sqflite.dart';

class LogProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table log ( 
            id integer primary key autoincrement, 
            sensor text not null,
            waarde text not null,
            datum text not null)
          ''');
    });
  }

  Future<LogModel> insert(LogModel logModel) async {
    logModel.id = await db.insert('log', logModel.toMap());
    return logModel;
  }

  Future<int> delete(int id) async {
    return await db.delete('log', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<LogModel>> getAll() async {

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('log');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return LogModel(
        id: maps[i]['id'],
        sensor: maps[i]['sensor'],
        waarde: maps[i]['waarde'],
        datum: maps[i]['datum'],
      );
    });
  }


  Future close() async => db.close();
}
