import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:duracellapp/SensorModel.dart';
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
      appBar: AppBar(
        title: Text("Log"),
        centerTitle: true,
        backgroundColor: Colors.brown.shade600,
      ),
      body:
        FutureBuilder<List<LogModel>>(
            future: DBProvider.db.getAllLogs(),
            builder: (BuildContext context, AsyncSnapshot<List<LogModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      LogModel item = snapshot.data[index];
                      return Card(
                        color: Colors.white,
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("Wilt u deze log verwijderen?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Annuleren",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Verwijderen",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              DBProvider.db.deleteLog(item.id);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                        },
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          child: ListTile(
                            title: Text(item.sensor),
                            subtitle: Text(item.waarde),
                            trailing: Text(item.datum),
                          ),
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

