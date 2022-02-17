import 'package:cloud_firestore/cloud_firestore.dart';

import 'Users.dart';

class Message {
  String id = "";
  Timestamp createdAt = Timestamp.now();
  String? image;
  String? video;
  String? text;
  Users? user;

  Message(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    createdAt = map["CREATED_AT"];
    image = map["IMAGE"];
    video = map["VIDEO"];
    text = map["TEXT"];
    user = map["USER"];
  }
}
