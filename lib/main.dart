import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crudoperations/firebase_options.dart';
import 'package:firebase_crudoperations/post.dart';
import 'package:firebase_crudoperations/stream_postscreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: Colors.deepPurple,
      )),
      home: StreamPostScreen(),
    );
  }
}
