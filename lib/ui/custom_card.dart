import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            child: ListTile(
              title: Text(snapshot.docs[index].get('title')),
              subtitle: Text(snapshot.docs[index].get('description')),
              leading: CircleAvatar(
                radius: 34,
                  child: Text(snapshot.docs[index].get('title').toString()[0]),
              ),
            ),
          ),
        ),
        Text(_getTimestamp())
        // Text((snapshot.docs[index].get('timestamp') == null) ? "N/A" : snapshot.docs[index].get('timestamp').toString())
        // Text(snapshot.docs[index].get('title'))
      ],
    );
  }

  String _getTimestamp() {
    try{
      return snapshot.docs[index].get('timestamp').toString();
    }
    catch(error) {
      return "";
    }

  }
}
