import 'package:flutter/material.dart';
import 'package:flutter_fireboard/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    home: BoardApp(),
  ));
}
