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
                    IconButton(icon: FaIcon(FontAwesomeIcons.edit, size: 15,), onPressed: (){}),
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
