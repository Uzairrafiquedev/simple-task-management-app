import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/login_screen.dart';
import 'package:task_management_app/services/auth_service.dart';

import 'home_screen.dart';

class SignupScreen extends StatelessWidget{
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Register here",style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.blue),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "email",
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                )
              ),
            ),
            TextField(
              controller: _passController,
              style: TextStyle(color: Colors.blue),
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                )
              ),
            ),
            ElevatedButton(onPressed: ()async{
              User? user = await _auth.registerWithEmailAndPassword(_emailController.text, _passController.text);
              if(user !=null){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              }
            }, child: Text("Register",style: TextStyle(fontSize: 18),),),
            Text("OR"),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
            }, child: Text("Log In",style: TextStyle(fontSize: 16),),),
          ],
        ),),

      ),
    );
  }

}