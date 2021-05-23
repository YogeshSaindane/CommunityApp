import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_app/db/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot itemObject;
  final int index;

  const CustomCard({Key key, this.itemObject, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeSec = new DateTime.fromMillisecondsSinceEpoch(
        itemObject.docs[index]["timestamp"].seconds * 1000);
    var newDate = new DateFormat("EEE, MMM d, y").format(timeSec);
    var snapshot = itemObject?.docs[index];
    var docID = snapshot.id;

    TextEditingController name_textfield =
        TextEditingController(text: snapshot["name"]);
    TextEditingController title_textfield =
        TextEditingController(text: snapshot["title"]);
    TextEditingController description_textfield =
        TextEditingController(text: snapshot["description"]);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Card(
          elevation: 5.0,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text(snapshot.get("name")[0]),
                ),
                title: Text(snapshot.get("title")),
                subtitle: Text(snapshot.get("description")),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "By: ${snapshot.get("name")}",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                    Text(
                      " on ${newDate.toString()}",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            // title: Text('Please update record'),
                            contentPadding: EdgeInsets.all(20),
                            content: Column(
                              children: [
                                Text("Please enter details"),
                                Expanded(
                                  child: TextField(
                                    autocorrect: true,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        labelText: "Your name*"),
                                    controller: name_textfield,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    autocorrect: true,
                                    autofocus: true,
                                    decoration:
                                        InputDecoration(labelText: "Title"),
                                    controller: title_textfield,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    autocorrect: true,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        labelText: "Description"),
                                    controller: description_textfield,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (name_textfield.text.isNotEmpty &&
                                      title_textfield.text.isNotEmpty &&
                                      description_textfield.text.isNotEmpty) {
                                    DataBase.boardDB
                                        .doc(docID)
                                        .update({
                                          "name": name_textfield.text,
                                          "title": title_textfield.text,
                                          "description":
                                              description_textfield.text,
                                          "timestamp": new DateTime.now(),
                                        })
                                        .then((response) => {
                                              name_textfield.clear(),
                                              title_textfield.clear(),
                                              description_textfield.clear(),
                                              Navigator.pop(context),
                                            })
                                        .catchError((err) => {print(err)});
                                  }
                                },
                                child: Text("Update"),
                              )
                            ],
                          ),
                        );
                      }),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        print(docID);
                        await DataBase.boardDB.doc(docID).delete();
                      }),
                ],
              )
            ],
          ),
        ),
      )

      // Text(itemObject?.docs[index].get("title") == null
      //     ? "yes"
      //     : itemObject?.docs[index]["title"]),
      // Text(itemObject["title"] ),
      // Text((itemObject.docs[index]["timestamp"]) ? "got it" : "N/A")
    ]);
  }

  // void _showDialog(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text('Add record'),
  //       contentPadding: EdgeInsets.all(20),
  //       content: Column(
  //         children: [
  //           Text("Please enter details"),
  //           Expanded(
  //             child: TextField(
  //               autocorrect: true,
  //               autofocus: true,
  //               decoration: InputDecoration(labelText: "Your name*"),
  //               controller: name_textfield,
  //             ),
  //           ),
  //           Expanded(
  //             child: TextField(
  //               autocorrect: true,
  //               autofocus: true,
  //               decoration: InputDecoration(labelText: "Title"),
  //               controller: title_textfield,
  //             ),
  //           ),
  //           Expanded(
  //             child: TextField(
  //               autocorrect: true,
  //               autofocus: true,
  //               decoration: InputDecoration(labelText: "Description"),
  //               controller: description_textfield,
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             _cancelAlertClicked();
  //             Navigator.pop(context);
  //           },
  //           child: Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (name_textfield.text.isNotEmpty &&
  //                 title_textfield.text.isNotEmpty &&
  //                 description_textfield.text.isNotEmpty) {
  //               DataBase.boardDB
  //                   .add(getAddObject())
  //                   .then((response) => {
  //                         print(response.id),
  //                         _cancelAlertClicked(),
  //                         Navigator.pop(context),
  //                       })
  //                   .catchError((err) => {print(err)});
  //             }
  //           },
  //           child: Text("Save"),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
