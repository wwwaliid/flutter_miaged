// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAGED',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MIAGED'),
          centerTitle: true,
        ),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return HomePage();
            }
            else{
              return LoginWidget();
            }
          },
        )
      ),
    );
  }

  
}

class LoginWidget extends StatefulWidget{
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            children: <Widget>[
              Center(
                child: Text('aaaaaaaaaaaaaaaaaaa'),
              ),
              Padding( 
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  )
                ),
              ),
              Padding( 
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
                  ),
                ), 
              ),
              Padding( 
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                  child: Text("Se connecter"),
                  onPressed: signIn,
                ), 
              ),
            ],
          ),
        ),
    );
  }
  
  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email : emailController.text.trim(),
      password : passwordController.text.trim(),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
    );
  }
}