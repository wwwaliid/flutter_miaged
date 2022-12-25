import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_network/image_network.dart';

import 'detailproduit.dart';



class PanierUser extends StatefulWidget {
  const PanierUser({super.key});

  @override
  State<PanierUser> createState() => _PanierUserState();
}

class _PanierUserState extends State<PanierUser> {

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String deleteid ="";

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
                                child: Text("Supprimer du panier"),
                                onPressed: () => supprimerpanier(snap[index].id),
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
    );
  }

  void supprimerpanier(String id) {
    log(id);
    FirebaseFirestore.instance.collection("panier").doc(uid).collection("produits").doc(id).delete();
    log("deleted");
  }
}