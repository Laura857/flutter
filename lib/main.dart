import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iim/view/dashboard.dart';
import 'package:flutter_iim/view/inscription.dart';

import 'functions/firestoreHelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationChannel notificationChannel = NotificationChannel(
      channelKey: 'single_channel',
      channelName: 'titre de la notif',
      channelDescription: 'description de la notif');
  NotificationChannel notificationChannel2 = NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'titre de la notif2',
      channelDescription: 'description de la notif2');
  AwesomeNotifications()
      .initialize(null, [notificationChannel, notificationChannel2]);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String?
      mail; // Avec le ? ça veut dire que c'est une variable optionnel sinon faut mettre une valeur par défaut
  String? password;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bienvenue"),
      ),
      body: Container(padding: EdgeInsets.all(20), child: bodyPage()),
    );
  }

//Widget bodyPage() {
// return Container(
//     padding: EdgeInsets.all(20),
//   decoration: BoxDecoration(
//     color: Colors.red,
//     shape: BoxShape.circle,
// borderRadius: BorderRadius.circular(20)
//   ),
//  width: 250,
//  height: 300,
//   child: Text("Je suis un texte",
//      style: TextStyle(
//            color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)));
//}

//Widget bodyPage() {
//  //return Image.asset("panda.png",
//  return Image.network("https://static.vecteezy.com/ti/vecteur-libre/t2/1339865-dessin-anime-mignon-panda-appuye-sur-le-mur-vectoriel.jpg",
// width: 500,
// height: 600);
//}

  Widget bodyPageColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
        Text("Fin du widget"),
      ],
    );
  }

  Widget bodyPageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
      ],
    );
  }

  Widget bodyPageScrollView() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
        Text("Bienvenue"),
        Image.asset("panda.png", width: 200, height: 300),
      ],
    ));
  }

  Widget bodyPageDismissible() {
    return Dismissible(
        key: Key("smlsmf"),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          print("coucou");
        },
        background: Container(
          color: Colors.red,
        ),
        child: Container(
          child: Text("Je suis un dissmissible"),
        ));
  }

  Widget bodyPage() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('panda.png'), fit: BoxFit.fill)),
        ),
        SizedBox(
          height: 15,
        ),
        //Text("$mail"),
        TextField(
          onChanged: (String text) {
            setState(() {
              mail = text;
            });
          },
          decoration: InputDecoration(
              icon: Icon(Icons.mail, color: Colors.pink),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
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
              icon: Icon(Icons.lock, color: Colors.pink),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),

        ElevatedButton(
            onPressed: () {
              FirestoreHelper()
                  .ConnectUser(mail: mail!, password: password!)
                  .then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return dashboard(mail, password);
                }));
              }).catchError((error) {
                print(error);
              });
            },
            child: Text("Connexion")),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return inscription();
            }));
          },
          child: Text(
            "Inscription",
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
