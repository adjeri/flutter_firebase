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
    return Column(
      children: [
        Container(
          height: 150,
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshot.docs[index].get('title')),
                  subtitle: Text(snapshot.docs[index].get('description')),
                  leading: CircleAvatar(
                    radius: 34,
                    child:
                        Text(snapshot.docs[index].get('title').toString()[0]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("By ${snapshot.docs[index].get('name')} "),
                      Text(_getTimestamp()),
                    ],
                  ),
                ),
              ],
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
