import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  @override
  _Log createState() => _Log();
}

class _Log extends State<Log> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<LogModel>>(
          future: DBProvider.db.getAllClients(),
          builder: (BuildContext context, AsyncSnapshot<List<LogModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    LogModel item = snapshot.data[index];
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(item.sensor),
                        subtitle: Text(item.waarde),
                        trailing: Text(item.datum),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
        onPressed: () async {
          DBProvider.db.deleteAll();
          setState(() {});
        },
      ),
    );
  }
}

