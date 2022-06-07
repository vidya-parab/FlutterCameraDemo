import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'display_photo.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null) {
        controller = CameraController(cameras![0], ResolutionPreset.max);

        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        }).catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                print('User denied camera access.');
                break;
              default:
                print('Handle other errors.');
                break;
            }
          }
        });
      } else {
        print("NO any camera found");
      }
    } catch (e) {}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unimoni Camera Demo"),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: Colors.blueGrey.withOpacity(0.5),
          child: Center(
            child: Container(
                height: 300,
                width: 400,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.blueGrey)),
                child: controller == null
                    ? Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(
                            controller!,
                          )),
          ),

          // Column(
          //     children:[
          //
          //
          //       /*Container( //show captured image
          //         padding: EdgeInsets.all(30),
          //         child: image == null?
          //         Text("No image captured"):
          //         Image.file(File(image!.path), height: 300,),
          //         //display captured image
          //       )*/
          //     ]
          // )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton.icon(
            //image capture button
            onPressed: () async {
              try {
                if (controller != null) {
                  //check if contrller is not null
                  if (controller!.value.isInitialized) {
                    //check if controller is initialized
                    image = await controller!.takePicture(); //capture image
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => DisplayPhoto(
                          path: image?.path ?? "",
                        ),
                      ),
                    );
                  }
                }
              } catch (e) {
                print(e); //show error
              }
            },
            icon: Icon(Icons.camera),
            label: Text("Capture"),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }
}
