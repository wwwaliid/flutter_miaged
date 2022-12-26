import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/profil.dart';
import 'package:image_network/image_network.dart';

import 'acheterscreen.dart';
import 'detailproduit.dart';



class PanierUser extends StatefulWidget {
  const PanierUser({super.key});

  @override
  State<PanierUser> createState() => _PanierUserState();
}

class _PanierUserState extends State<PanierUser> {

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  int index = 0;
  int total=0;

@override
  void initState() {
    index = 0;
    super.initState();
    Stream<QuerySnapshot<Map<String, dynamic>>> products = FirebaseFirestore.instance.collection("panier").doc(uid).collection("produits").snapshots();
    products.forEach((field) {
      field.docs.asMap().forEach((index, data) {
        setState(() {
          total += int.parse(field.docs[index]["prix"]);
        });
        log(total.toString());
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MIAGED'),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Somme du panier : "+total.toString()+" DH"),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("panier").doc(uid).collection("produits").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8.0),
                    primary: false,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // return Text(snap[index]['titre'] + "  " + snap[index]['taille'] + "  " + snap[index]['prix']);
                      return GestureDetector(
                        onTap:() {
                          log("clicked");
                          Map produit = {"titre" : snap[index]['titre'], "taille" : snap[index]['taille'], "prix" : snap[index]['prix'], "imageurl" : snap[index]['imageurl'], "marque" : snap[index]["marque"]};
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailProduit(produit),),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(snap[index]['titre']),
                              ),
                              ImageNetwork(image: snap[index]['imageurl'], height: 150, width: 150,),
                              //Image.network('../images.tshirt.jpg',height:150),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Taille : "+snap[index]['taille']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(snap[index]['prix'] + " DH"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Icon(Icons.close),
                                onPressed: () => supprimerpanier(snap[index].id, snap[index]['prix']),
                              ),
                            ], 
                          ),
                        )
                      ); 
                  }
                  
                );
                }
                else{
                  return Text("ggggg");
                }
              }
            )
          ],
        ),
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

  void supprimerpanier(String id, String prix) {
    log(id);
    FirebaseFirestore.instance.collection("panier").doc(uid).collection("produits").doc(id).delete();
    log("deleted");
    setState(() {
      total -= int.parse(prix);
    });
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