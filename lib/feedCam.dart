import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:prototype01/main.dart';

import 'home.dart';


class FeedCam extends StatefulWidget {
  const FeedCam({super.key});

  @override
  State<FeedCam> createState() => _FeedCamState();
}

class _FeedCamState extends State<FeedCam> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  var awake_var = 0;
  var drowsi_var = 0;
  var sleep_var =0;


  @override
  void initState(){
    super.initState();
    loadCamera();
    //loadmodel();
    tempRand();


  }

  @override
  void dispose() {
    // you can add to close tflite if error is caused by tflite
    Tflite.close();
    cameraController!.dispose(); // this is to dispose camera controller if you are using live detection
    super.dispose();
  }

  tempRand(){
    Timer.periodic(Duration(seconds: 3), (_) {
      setState(() {
        awake_var = Random().nextInt(50) + 50; // Value is >= 0 and < 100.
        drowsi_var = Random().nextInt(10) + 50; // Value is >= 0 and < 100.
        sleep_var = Random().nextInt(5) + 20;
      });
    });
  }

  loadCamera(){
    cameraController = CameraController(cameras![1], ResolutionPreset.medium);
    cameraController!.initialize().then((value){
      if(!mounted){
        return;
      }else{
        setState(() {
          cameraController!.startImageStream((imageStream){
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async{
    if(cameraImage! != null){
      var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane){
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height,
      imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true
      );
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }
  
  loadmodel() async{
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/label.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(22,149,163, 1),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink,
          title: Text('DriveAlerto®', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          elevation: 0,
        ),
    body: Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,


    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
    // Section 1 - Illustration
                  Container(
                    color: Colors.grey,
                    width: 350,
                    height: 450,
                    child: Center(
                      child: !cameraController!.value.isInitialized?
                      Container():
                      AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),)
                    ),
                  ),
                Container(
                  color: Colors.grey,
                  width: 350,
                  height: 150,
                  child: Card(
                    child: Column(

                      children: [
                        Row(
                            children: [
                              Text(output)
                            ]
                        ),
                        Row(
                          children: [
                            Text('Awake :'),
                            Text('${awake_var} %')
                          ]
                          ),
                        Row(
                            children: [
                              Text('Drowsi :'),
                              Text('${drowsi_var} %')
                            ]
                        ),
                        Row(
                            children: [
                              Text('Sleep :'),
                              Text('${sleep_var} %')
                            ]
                        ),
                      ]
                    )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text(
                      'Stop',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),

    )

    );
  }
}
