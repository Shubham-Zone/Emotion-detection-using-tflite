import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

class EmotionDetection extends StatefulWidget {
  const EmotionDetection({super.key});

  @override
  State<EmotionDetection> createState() => _EmotionDetectionState();
}

class _EmotionDetectionState extends State<EmotionDetection> {

  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = 'Emotions';


  @override
  void initState() {
    loadCamera();
    loadModel();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    Tflite.close();

  }

  loadCamera() async {

    // Get available cameras
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await cameraController!.initialize().then((value){

      if(!mounted){
        return;
      }else{
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });

        });

      }

    });

  }

  runModel() async {
    if (cameraImage != null ) {
      try {

        var recognitions = await Tflite.runModelOnFrame(
            bytesList: cameraImage!.planes.map((plane) {return plane.bytes;}).toList(),// required
            imageHeight: cameraImage!.height,
            imageWidth: cameraImage!.width,
            imageMean: 127.5,   // defaults to 127.5
            imageStd: 127.5,    // defaults to 127.5
            rotation: 90,       // defaults to 90, Android only
            numResults: 2,      // defaults to 5
            threshold: 0.1,     // defaults to 0.1
            asynch: true        // defaults to true
        );

        recognitions!.forEach((element) {
          setState(() {
            output = element['label'];
          });
        });

      } catch (e) {

        print("Error running model: $e");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error running model: $e")));
      }
    }
  }

  loadModel() async {

    // Loading the model
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live emotion detection'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: !cameraController!.value.isInitialized
                  ? Container()
                  : AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(output, style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),),
        ],
      ),
    );
  }
}
