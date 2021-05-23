import 'package:community_app/UI/CustomeCard.dart';
import 'package:community_app/db/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  final Stream<QuerySnapshot> firestoreDB = DataBase.boardDB.snapshots();
  // ignore: non_constant_identifier_names
  TextEditingController name_textfield;
  TextEditingController title_textfield;
  TextEditingController description_textfield;

  @override
  void initState() {
    // s
    super.initState();

    name_textfield = TextEditingController();
    title_textfield = TextEditingController();
    description_textfield = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      body: StreamBuilder(
        stream: firestoreDB,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int index) {
                print(snapshot.data);
                // return Text(snapshot.data.docs[index]["name"]);
                return CustomCard(itemObject: snapshot.data, index: index);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Add record'),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          children: [
            Text("Please enter details"),
            Expanded(
              child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Your name*"),
                controller: name_textfield,
              ),
            ),
            Expanded(
              child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Title"),
                controller: title_textfield,
              ),
            ),
            Expanded(
              child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Description"),
                controller: description_textfield,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _cancelAlertClicked();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (name_textfield.text.isNotEmpty &&
                  title_textfield.text.isNotEmpty &&
                  description_textfield.text.isNotEmpty) {
                DataBase.boardDB
                    .add(getAddObject())
                    .then((response) => {
                          print(response.id),
                          _cancelAlertClicked(),
                          Navigator.pop(context),
                        })
                    .catchError((err) => {print(err)});
              }
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  Map<String, dynamic> getAddObject() {
    return {
      "name": name_textfield.text,
      "title": title_textfield.text,
      "description": description_textfield.text,
      "timestamp": new DateTime.now(),
    };
  }

  _cancelAlertClicked() {
    name_textfield.clear();
    title_textfield.clear();
    description_textfield.clear();
  }
}
