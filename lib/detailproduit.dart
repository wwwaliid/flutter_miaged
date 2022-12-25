import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_network/image_network.dart';

class DetailProduit extends StatelessWidget {
  const DetailProduit(this.produit, {super.key});
  final Map produit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MIAGED'),
          centerTitle: true,
        ),
      body: Column(
        children: [
          Text(produit["titre"]),
          ImageNetwork(image: produit["imageurl"], height: 150, width: 150,),
          Text("Marque : " + produit["marque"]),
          Text("Taille : " + produit["taille"]),
          Text(produit["prix"] + " DH"),
          ElevatedButton(
            child: Text("Ajouter au panier"),
            onPressed: ajouterpanier,
          ), 
        ],
      ),
    );
  }

  void ajouterpanier() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    final CollectionReference panier = FirebaseFirestore.instance.collection("panier");
    //produit["titre"],produit["taille"],produit["prix"],produit["marque"],produit["imageurl"]
    Future addtopanier(String titre, String taille, String prix, String marque, String imageurl) async {
      return await panier.doc(uid).collection("produits").doc().set({
        "titre":titre,
        "taille":taille,
        "prix":prix,
        "marque":marque,
        "imageurl":imageurl,
      });
    }
    addtopanier(produit["titre"],produit["taille"],produit["prix"],produit["marque"],produit["imageurl"]);
    

  }
}
