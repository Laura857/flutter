import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_iim/controller/afficherCarte.dart';
import 'package:flutter_iim/controller/allMorceaux.dart';
import 'package:flutter_iim/controller/character.dart';

import '../controller/addMorceau.dart';
import 'Mydrawer.dart';

class dashboard extends StatefulWidget {
  String? mail;
  String? password;

  dashboard(String? this.mail, String? this.password);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashboardState();
  }
}

class dashboardState extends State<dashboard> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Ici on met ce qu'on veut, on recommance une nouvelle page en faite
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Nouvelle page'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return addMorceau();
                  }));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: bodyPage(currentIndex),
        bottomNavigationBar: DotNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.amber,
            onTap: (int newValue) {
              setState(() {
                currentIndex = newValue;
              });
            },
            currentIndex: currentIndex,
            items: [
              DotNavigationBarItem(
                icon: Icon(Icons.music_note_sharp),
              ),
              DotNavigationBarItem(
                icon: Icon(Icons.person),
              ),
              DotNavigationBarItem(
                icon: Icon(Icons.map_sharp),
              ),
            ]));
  }

  Widget bodyPage(int value) {
    switch (value) {
      case 0:
        return allMorceaux();
      case 1:
        return character();
      case 2:
        return afficherCarte();
      default:
        return Text("Aucune info");
    }
  }
}
