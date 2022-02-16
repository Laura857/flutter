import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iim/view/musicDetails.dart';

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
        if (snapshot.data!.docs.isEmpty) {
          return Container(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(),
          );
        }
        List documents = snapshot.data!.docs;
        return GridView.builder(
            itemCount: documents.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              Morceau musique = Morceau(documents[index]);
              return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: (musique.image == null || musique.image == "")
                                ? NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/firstprojetimm.appspot.com/o/image_disponible.png?alt=media&token=809cfa6c-b1af-44e1-bd85-a12ae9ef0f39")
                                : NetworkImage(musique.image!))),
                  ),
                  onTap: () {
                    (musique.song_path == null)
                        ? Container()
                        : Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                            return musicDetails(musique);
                          }));
                  });
            });
      },
    );
  }
}
