class SensorModel {
  int id;
  String sensor;
  int isSubscribed;

  SensorModel({this.id, this.sensor, this.isSubscribed});

  factory SensorModel.fromMap(Map<String, dynamic> json) => new SensorModel(
      id: json["id"],
      sensor: json["sensor"],
      isSubscribed: json["isSubscribed"]
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sensor': sensor,
      'isSubscribed': isSubscribed
    };
  }
}