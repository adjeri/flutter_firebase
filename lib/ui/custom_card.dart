import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.docs[index];
    var docId = snapshot.docs[index].id;
    TextEditingController nameInputController = TextEditingController(text: snapshotData.get('name'));
    TextEditingController titleInputController = TextEditingController(text: snapshotData.get('title'));
    TextEditingController descriptionInputController = TextEditingController(text: snapshotData.get('description'));
    return Column(
      children: [
        Container(
          height: 190,
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshotData.get('title')),
                  subtitle: Text(snapshotData.get('description')),
                  leading: CircleAvatar(
                    radius: 34,
                    child:
                        Text(snapshotData.get('title').toString()[0]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("By ${snapshotData.get('name')} "),
                      Text(_getTimestamp()),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(icon: FaIcon(FontAwesomeIcons.edit, size: 15,), onPressed: () async {
                      await showDialog(context: context,
                        child: AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          content: Column(
                            children: [
                              Text("Please fill out the form to update"),
                              Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    autocorrect: true,
                                    decoration: InputDecoration(labelText: "Your Name *"),
                                    controller: nameInputController,
                                  )),
                              Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    autocorrect: true,
                                    decoration: InputDecoration(labelText: "Title *"),
                                    controller: titleInputController,
                                  )),
                              Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    autocorrect: true,
                                    decoration: InputDecoration(labelText: "Description*"),
                                    controller: descriptionInputController,
                                  )),
                            ],
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                nameInputController.clear();
                                titleInputController.clear();
                                descriptionInputController.clear();
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            FlatButton(
                              onPressed: () {
                                if (titleInputController.text.isNotEmpty &&
                                    nameInputController.text.isNotEmpty &&
                                    descriptionInputController.text.isNotEmpty) {
                                  FirebaseFirestore.instance.collection("board")
                                      .doc(docId)
                                      .update({
                                    "name": nameInputController.text,
                                    "title": titleInputController.text,
                                    "description": descriptionInputController.text,
                                    "timestamp": new DateTime.now()
                                  }).then((value) => Navigator.pop(context));
                                  // FirebaseFirestore.instance.collection("board").add({
                                  //   "name": nameInputController.text,
                                  //   "title": titleInputController.text,
                                  //   "description": descriptionInputController.text,
                                  //   "timestamp": new DateTime.now()
                                  // }).then((response) {
                                  //   print(response.id);
                                  //   nameInputController.clear();
                                  //   titleInputController.clear();
                                  //   descriptionInputController.clear();
                                  //   Navigator.pop(context);
                                  // }).catchError((error) => print(error));
                                }
                              },
                              child: Text("Update"),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20,),
                    IconButton(icon: FaIcon(FontAwesomeIcons.trashAlt, size: 15,), onPressed: () async {
                      await FirebaseFirestore.instance.collection("board").doc(docId).delete();
                    })
                  ],
                ),
              ], // Widget
            ),
          ),
        ),
      ],
    );
  }

  String _getTimestamp() {
    try {
      var timeToDate = new DateTime.fromMillisecondsSinceEpoch(
          snapshot.docs[index].get('timestamp').seconds * 1000);
      var dateFormatted = new DateFormat("EEEE, MMM d, y").format(timeToDate);
      return dateFormatted.toString();
    } catch (error) {
      return "";
    }
  }
}
