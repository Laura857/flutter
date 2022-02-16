import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iim/functions/firestoreHelper.dart';
import 'package:flutter_iim/view/dashboard.dart';

class inscription extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return inscriptionState();
  }
}

class inscriptionState extends State<inscription> {
  String? prenom;
  String? nom;
  String? mail;
  String? password;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Column(children: [
      TextField(
        onChanged: (String text) {
          setState(() {
            nom = text;
          });
        },
        decoration: InputDecoration(
          hintText: "Entrer votre nom",
          icon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      TextField(
        onChanged: (String text) {
          setState(() {
            prenom = text;
          });
        },
        decoration: InputDecoration(
          hintText: "Entrer votre prénom",
          icon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      TextField(
        onChanged: (String text) {
          setState(() {
            mail = text;
          });
        },
        decoration: InputDecoration(
          hintText: "Entrer votre mail",
          icon: Icon(Icons.mail),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      TextField(
        obscureText: true,
        onChanged: (String text) {
          setState(() {
            password = text;
          });
        },
        decoration: InputDecoration(
          hintText: "Entrer votre password",
          icon: Icon(Icons.lock),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      ElevatedButton(
          onPressed: () {
            FirestoreHelper().CreationUser(
                mail: mail, password: password, prenom: prenom, nom: nom);
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 89,
                  channelKey: 'basic_channel',
                  body: 'Votre compte a bien été créée'),
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return dashboard(mail, password);
            }));
          },
          child: Text("Inscription"))
    ]);
  }
}
