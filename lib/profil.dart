import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/panieruser.dart';

import 'acheterscreen.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  User? userconnected = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  final anniversaireController = TextEditingController();
  final adresseController = TextEditingController();
  final postalController = TextEditingController();
  final villeController = TextEditingController();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection("users").doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      var data = documentSnapshot.data();
      var res = data as Map<String, dynamic>;
      anniversaireController.text = res["anniversaire"];
      adresseController.text = res["adresse"];
      postalController.text = res["postal"];
      villeController.text = res["ville"];
    });

    loginController.text = userconnected?.email as String;
    
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginController.dispose();
    passwordController.dispose();
    anniversaireController.dispose();
    adresseController.dispose();
    postalController.dispose();
    villeController.dispose();
    super.dispose();
  }
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MIAGED'),
          centerTitle: true,
        ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child:Text("Mon Profil"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              enabled: false,
              controller: loginController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
                hintText: 'Entrer Login',
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Entrer password',
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              controller: anniversaireController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Anniversaire',
                hintText: 'Entrer Anniversaire',
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              controller: adresseController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Adresse',
                hintText: 'Entrer adresse',
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: postalController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code postal',
                hintText: 'Entrer code postal',
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              controller: villeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ville',
                hintText: 'Entrer Ville',
              )
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text("Valider"),
              onPressed: () => {valider()},
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text("Se déconnecter"),
              onPressed: () => {signout()},
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: switchpage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
  void switchpage(int index) {
    setState(() {
      index = index;
    });
    if(index==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AcheterScreen(),),
      );
    }
    else if(index==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PanierUser(),),
      );
    }
    else if(index==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profil(),),
      );
    }
  }
  
  void signout() {
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }
    _signOut();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>MyApp(),),
      );
  }
  
  void valider() {
    
    userconnected?.updatePassword(passwordController.text.trim());
    log(passwordController.text.trim());
    final CollectionReference users = FirebaseFirestore.instance.collection("users");
    Future validerinfo() async {
      return await users.doc(uid).set({
        "login":loginController.text.trim(),
        "anniversaire":anniversaireController.text.trim(),
        "adresse":adresseController.text.trim(),
        "postal":postalController.text.trim(),
        "ville":villeController.text.trim(),
      });
    }
    validerinfo();
  }
}