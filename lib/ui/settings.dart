import 'dart:collection';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:device_info/device_info.dart';
import 'package:duracellapp/Database.dart';
import 'package:duracellapp/SensorModel.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {

  @override
  void initState() {
    super.initState();
  }

  bool _sensor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<List<SensorModel>>(
        future: DBProvider.db.getAllSensors(),
        builder: (BuildContext context, AsyncSnapshot<List<SensorModel>> snapshot) {
          if (snapshot.hasData) {
            return Center(
              children: TextField()
              child: ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    SensorModel item = snapshot.data[index];
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SwitchListTile(
                          value: (item.isSubscribed == 1)? true : false,
                          onChanged: (bool value) { setState(() {
                            if(value == true){
                              item.isSubscribed = 1;
                              print(item.isSubscribed.toString() + "is 1");
                            }else{
                              item.isSubscribed = 0;
                              print(item.isSubscribed.toString() + "is 0");
                              resetConnection(context, item.sensor);
                            }
                            DBProvider.db.updateSensor(item);
                            receive(new List<String>(), context);
                          });},
                          title: Text(item.sensor),
                          subtitle: Text(item.isSubscribed.toString()),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                        return Divider();
                  },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void resetConnection(BuildContext context, String unsub){
  ConnectionSettings settings = new ConnectionSettings(
      host: "10.148.22.219"
  );
  print("unsub");
  Client client = new Client(settings: settings);
  client.channel()
      .then((Channel channel) async {
        channel.queue(await _getId(context));
        return channel.exchange("hello_direct", ExchangeType.DIRECT, durable: false);
      })
      .then((Exchange exchange) async{
        exchange.channel.queue(await _getId(context)) .then((Queue queue) {
          return queue.unbind(exchange, unsub);
        });
  });
}

Future<String> _getId(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}


