import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/panieruser.dart';

import 'acheterscreen.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  User? userconnected = FirebaseAuth.instance.currentUser;
  
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final anniversaireController = TextEditingController();
  final adresseController = TextEditingController();
  final postalController = TextEditingController();
  final villeController = TextEditingController();

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
          Center(
            child:Text("Mon Profil"),
          ),
          TextField(
            controller: loginController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Login',
              hintText: 'Entrer Login',
            )
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Entrer password',
            )
          ),
          TextField(
            controller: anniversaireController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Anniversaire',
              hintText: 'Entrer Anniversaire',
            )
          ),
          TextField(
            controller: adresseController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Adresse',
              hintText: 'Entrer adresse',
            )
          ),
          TextField(
            controller: postalController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Code postal',
              hintText: 'Entrer code postal',
            )
          ),
          TextField(
            controller: villeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ville',
              hintText: 'Entrer Ville',
            )
          ),
          ElevatedButton(
            child: Text("Valider"),
            onPressed: () => {},
          ),
          ElevatedButton(
            child: Text("Se déconnecter"),
            onPressed: () => {},
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
}