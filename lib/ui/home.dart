import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection("board").snapshots();
  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community builder"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showDialog(context);
      },
        child: FaIcon(FontAwesomeIcons.pen)),
      body: StreamBuilder(stream: firestoreDb, builder: (context,snapshot){
        if(!snapshot.hasData)
        return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context,int index){
            return Text(snapshot.data.documents[index].get('title'));
        });
      }),
    );
  }
  _showDialog(BuildContext context) async {
    await showDialog(context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            children: [
              Text("Please fill out the form"),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: "Your Name *"
                ),
                controller: nameInputController,
              )),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Title *"
                ),
                controller: titleInputController,
              )),
              Expanded(child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Description*"
                ),
                controller: descriptionInputController,
              )),
            ],
          ),
          actions: [
            FlatButton(onPressed: (){
              nameInputController.clear();
              titleInputController.clear();
              descriptionInputController.clear();
              Navigator.pop(context);
            },
              child: Text("Cancel"),
            ),
            FlatButton(onPressed: (){
              if(titleInputController.text.isNotEmpty &&
              nameInputController.text.isNotEmpty &&
              descriptionInputController.text.isNotEmpty
              ){
                FirebaseFirestore.instance.collection("board")
                    .add({
                  "name": nameInputController.text,
                  "title": titleInputController.text,
                  "description": descriptionInputController.text,
                  "timestamp" : new DateTime.now()
                }).then((response) {
                  print(response.id);
                  nameInputController.clear();
                  titleInputController.clear();
                  descriptionInputController.clear();
                  Navigator.pop(context);
                }).catchError((error) => print(error));
              }
            },
              child: Text("Save"),
            ),
          ],
        )
    );
  }
}
