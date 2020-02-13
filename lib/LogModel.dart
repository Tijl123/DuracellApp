class LogModel {
  int id;
  String sensor;
  String waarde;
  String datum;

  LogModel({this.id, this.sensor, this.waarde, this.datum});

  factory LogModel.fromMap(Map<String, dynamic> json) => new LogModel(
    id: json["id"],
    sensor: json["sensor"],
    waarde: json["waarde"],
    datum: json["datum"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sensor': sensor,
      'waarde': waarde,
      'datum': datum,
    };
  }
}


