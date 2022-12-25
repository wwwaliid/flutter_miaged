import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/detailproduit.dart';
import 'package:image_network/image_network.dart';

class AcheterScreen extends StatefulWidget {
  const AcheterScreen({super.key});

  @override
  State<AcheterScreen> createState() => _AcheterScreenState();
}

class _AcheterScreenState extends State<AcheterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("vetements").snapshots(),
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
}