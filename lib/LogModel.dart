class LogModel {
  int id;
  String sensor;
  String waarde;
  String datum;
  int isConfirmed;
  String prioriteit;

  LogModel({this.id, this.sensor, this.waarde, this.datum, this.isConfirmed, this.prioriteit});

  factory LogModel.fromMap(Map<String, dynamic> json) => new LogModel(
    id: json["id"],
    sensor: json["sensor"],
    waarde: json["waarde"],
    datum: json["datum"],
    isConfirmed: json["isConfirmed"],
    prioriteit: json["prioriteit"]
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sensor': sensor,
      'waarde': waarde,
      'datum': datum,
      'isConfirmed': isConfirmed,
      'prioriteit': prioriteit
    };
  }
}


