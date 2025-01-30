import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/home_screen.dart';
import 'package:task_management_app/signup_screen.dart';

import 'login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:FirebaseOptions(
        apiKey: "AIzaSyC-WvjuRy_CcNR7BHpZec7rSLat9tMcvHo",
        appId: "1:170510013649:android:dec7ec9502199e142ca1f0",
        messagingSenderId: "170510013649",
        projectId: "task-management-app-95f35")

  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task management App",
      home: _auth.currentUser!=null ? HomeScreen():LoginScreen(),
    );
  }

}