class LogModel {
  int id;
  String sensor;
  String waarde;
  String datum;

  LogModel({this.id, this.sensor, this.waarde, this.datum});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'sensor': sensor,
      'waarde': waarde,
      'datum': datum
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  LogModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    sensor = map['sensor'];
    datum = map['datum'];
  }
}
