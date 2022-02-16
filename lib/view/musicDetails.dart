import 'package:flutter/material.dart';
import 'package:flutter_iim/functions/firestoreHelper.dart';
import 'package:flutter_iim/model/Morceau.dart';

class musicDetails extends StatefulWidget {
  Morceau morceau;

  musicDetails(Morceau this.morceau);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return musicDetailsState();
  }
}

class musicDetailsState extends State<musicDetails> {
  double musicTime = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.morceau.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Column(children: [
      Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: (widget.morceau.image == null)
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/firstprojetimm.appspot.com/o/image_disponible.png?alt=media&token=809cfa6c-b1af-44e1-bd85-a12ae9ef0f39")
                  : NetworkImage(widget.morceau.image!),
              fit: BoxFit.fill),
        ),
      ),
      SizedBox(height: 10),
      Text(widget.morceau.title),
      Text(widget.morceau.author),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.fast_rewind)),
          IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
          IconButton(onPressed: () {}, icon: Icon(Icons.fast_forward)),
        ],
      ),
      Slider(
        min: 0.0,
        max: 100.0,
        value: musicTime,
        onChanged: (value) {
          setState(() {
            musicTime = value;
          });
        },
      )
    ]);
  }
}
