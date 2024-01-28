import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:prototype01/main.dart';


class FeedCam extends StatefulWidget {
  const FeedCam({super.key});

  @override
  State<FeedCam> createState() => _FeedCamState();
}

class _FeedCamState extends State<FeedCam> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState(){
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera(){
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
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
    if(cameraImage!=null){
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
    await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/label.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(22,149,163, 1),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink,
          title: Text('STATUS : ACTIVE / NOT ACTIVE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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
                      child: cameraController!.value.isInitialized?
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
                            Text('100%')
                          ]
                          ),
                        Row(
                            children: [
                              Text('Drowsi :'),
                              Text('0%')
                            ]
                        ),
                        Row(
                            children: [
                              Text('Sleep :'),
                              Text('0%')
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
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedCam()));
                    },
                    child: Text(
                      'Start / Stop',
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
