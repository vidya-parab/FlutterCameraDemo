import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPhoto extends StatefulWidget {
  final String? path;

  const DisplayPhoto({Key? key, this.path}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DisplayPhotoState();
  }
}

class DisplayPhotoState extends State<DisplayPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unimoni Camera Demo"),
          backgroundColor: Colors.redAccent,
        ),
        body:
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            margin: EdgeInsets.all(10),
            child: Center(
              child: Image.file(File(widget.path!),  height: 300,
                width: 400,fit: BoxFit.fill,),
            ),
          )
        );
  }
}
