import 'package:cloud_firestore/cloud_firestore.dart';

class Morceau {
  String id = "";
  String title = "";
  String author = "";
  String song_path = "";
  String? album_title;
  String? image;
  String? type;

  Morceau(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map["TITLE"];
    author = map["AUTHOR"];
    album_title = map["ALBUM_TITLE"];
    image = map["IMAGE"];
    type = map["TYPE"];
    song_path = map["SONG_PATH"];
  }
}
