import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/services/auth_service.dart';
import 'package:task_management_app/signup_screen.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget{
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),

      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            children: [
              Text("Log In here",style: TextStyle(
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
                User? user = await _auth.signInWithEmailAndPassword(_emailController.text, _passController.text);
                if(user !=null){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                }
              }, child: Text("Log In",style: TextStyle(fontSize: 18),),),
              Text("OR"),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
              }, child: Text("Create Account",style: TextStyle(fontSize: 16),),),
            ],
          ),),

      ),
    );
  }

}