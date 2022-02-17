import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:random_string/random_string.dart';

import '../functions/firestoreHelper.dart';
import '../model/Message.dart';
import '../model/Users.dart';

class chat extends StatefulWidget {
  Users user;

  chat(Users this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chatState();
  }
}

class chatState extends State<chat> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  List<ChatMessage> messages = <ChatMessage>[];
  var m = <ChatMessage>[];

  String uid = "";

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState!.scrollController
          ..animateTo(
            _chatViewKey
                .currentState!.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
    Map<String, dynamic> map = {
      "CREATED_AT": message.createdAt,
      //"USER": message.createdAt,
      "TEXT": message.text,
      "IMAGE": message.image,
      "VIDEO": message.video,
    };
    String uid = randomAlphaNumeric(20);
    FirestoreHelper().addMessage(uid, map);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.prenom! + " " + widget.user.nom!),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    ChatUser user = ChatUser(
        name: widget.user.pseudo,
        uid: uid,
        avatar: widget.user.image,
        lastName: widget.user.nom,
        firstName: widget.user.prenom);

    FirestoreHelper().getIdentifiant().then((value) {
      uid = value;
    });

    return StreamBuilder<QuerySnapshot>(
        stream:
            FirestoreHelper().fire_message.orderBy("CREATED_AT").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            List documents = snapshot.data!.docs;
            print(Message(documents[0]));
            var databaseMessage = documents.map((i) => Message(i)).toList();
            var messages = databaseMessage
                .map((i) => ChatMessage(
                    id: i.id,
                    image: i.image,
                    video: i.video,
                    text: i.text,
                    user: ChatUser(
                        uid: uid,
                        name: i.user?.pseudo,
                        firstName: i.user?.prenom,
                        lastName: i.user?.nom)))
                .toList();

            return DashChat(
              key: _chatViewKey,
              inverted: false,
              onSend: onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration:
                  InputDecoration.collapsed(hintText: "Add message here..."),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: false,
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              alwaysShowSend: true,
              inputTextStyle: TextStyle(fontSize: 16.0),
              inputContainerStyle: BoxDecoration(
                border: Border.all(width: 0.0),
                color: Colors.white,
              ),
              onQuickReply: (Reply reply) {
                setState(() {
                  messages.add(ChatMessage(
                      text: reply.value,
                      createdAt: DateTime.now(),
                      user: user));

                  messages = [...messages];
                });

                Timer(Duration(milliseconds: 300), () {
                  _chatViewKey.currentState!.scrollController
                    ..animateTo(
                      _chatViewKey.currentState!.scrollController.position
                          .maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );

                  if (i == 0) {
                    systemMessage();
                    Timer(Duration(milliseconds: 600), () {
                      systemMessage();
                    });
                  } else {
                    systemMessage();
                  }
                });
              },
              onLoadEarlier: () {
                print("laoding...");
              },
              shouldShowLoadEarlier: false,
              showTraillingBeforeSend: true,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    //final picker = ImagePicker();
                    // PickedFile? result = await picker.getImage(
                    //  source: ImageSource.gallery,
                    //  imageQuality: 80,
                    //  maxHeight: 400,
                    //  maxWidth: 400,
                    //);

                    //if (result != null) {
                    // final Reference storageRef =
                    //     FirebaseStorage.instance.ref().child("chat_images");

                    // final taskSnapshot = await storageRef.putFile(
                    //   File(result.path),
                    //  SettableMetadata(
                    //    contentType: 'image/jpg',
                    //  ),
                    // );

                    // String url = await taskSnapshot.ref.getDownloadURL();

                    // ChatMessage message =
                    //     ChatMessage(text: "", user: user, image: url);

                    // FirebaseFirestore.instance
                    //     .collection('messages')
                    //     .add(message.toJson());
                    //}
                  },
                )
              ],
            );
          }
        });
  }
}
