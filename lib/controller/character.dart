import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iim/functions/firestoreHelper.dart';

import '../model/Users.dart';

class character extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return characterState();
  }
}

class characterState extends State<character> {
  String uid = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: bodyPage(),
    );
  }

  Widget bodyPage() {
    FirestoreHelper().getIdentifiant().then((value) {
      uid = value;
    });
    return StreamBuilder<QuerySnapshot>(
      //récupère tout ceux avec le mail
      //stream: FirestoreHelper().fire_user.where("MAIL", isEqualTo: "test@gmail.com").snapshots(),
      stream: FirestoreHelper().fire_user.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              height: 50, width: 50, child: CircularProgressIndicator());
        }
        List documents = snapshot.data!.docs;
        return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Users utilsateur = Users(documents[index]);
              if (utilsateur.id == uid) {
                return Container();
              }
              return Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.teal,
                child: ListTile(
                  leading: (utilsateur.image == null)
                      ? Container()
                      : Image.network(
                          utilsateur.image!,
                          width: 20,
                          height: 20,
                        ),
                  title: Text("${utilsateur.prenom} ${utilsateur.nom}"),
                  subtitle: Text("${utilsateur.mail}"),
                ),
              );
            });
      },
    );
  }
}
