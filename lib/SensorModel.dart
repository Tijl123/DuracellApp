class SensorModel {
  int id;
  String sensor;

  SensorModel({this.id, this.sensor});

  factory SensorModel.fromMap(Map<String, dynamic> json) => new SensorModel(
      id: json["id"],
      sensor: json["sensor"]
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sensor': sensor
    };
  }
}