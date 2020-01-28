class LogModel {
  int id;
  String sensor;
  String waarde;
  String datum;
  int isChecked;

  LogModel({this.id, this.sensor, this.waarde, this.datum, this.isChecked});

  factory LogModel.fromMap(Map<String, dynamic> json) => new LogModel(
    id: json["id"],
    sensor: json["sensor"],
    waarde: json["waarde"],
    datum: json["datum"],
    isChecked: json["isChecked"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sensor': sensor,
      'waarde': waarde,
      'datum': datum,
      'isChecked': isChecked
    };
  }
}


