import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../functions/firestoreHelper.dart';
import '../model/Morceau.dart';

class allMorceaux extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return allMorceauxState();
  }
}

class allMorceauxState extends State<allMorceaux> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: bodyPage(),
    );
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().fire_morceaux.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              height: 50, width: 50, child: CircularProgressIndicator());
        }
        List documents = snapshot.data!.docs;
        return GridView.builder(
            itemCount: documents.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              Morceau musique = Morceau(documents[index]);
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:
                    DecorationImage(image: NetworkImage(musique.image!))),
              );
            });
      },
    );
  }
}
