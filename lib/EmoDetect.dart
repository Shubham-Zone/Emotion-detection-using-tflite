// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'main.dart';
//
// class EmotionDetection2 extends StatefulWidget {
//   const EmotionDetection2({super.key});
//
//   @override
//   State<EmotionDetection2> createState() => _EmotionDetection2State();
// }
//
// class _EmotionDetection2State extends State<EmotionDetection2> {
//
//   CameraController? cameraController;
//   CameraImage? cameraImage;
//   String output = 'Emotions';
//   Interpreter? interpreter;
//   List<String> emotionLabels = []; // Assuming emotion labels are stored in a list
//
//   @override
//   void initState() {
//     loadCamera();
//     loadTfliteModel();
//     loadLabels(); // Added: Load emotion labels
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     cameraController?.dispose();
//     interpreter?.close();
//   }
//
//   loadCamera() async {
//     cameras = await availableCameras();
//     cameraController = CameraController(cameras![1], ResolutionPreset.medium);
//     cameraController!.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {
//         cameraController!.startImageStream((imageStream) {
//           cameraImage = imageStream;
//           if (cameraImage != null) {
//             runModel();
//           }
//         });
//       });
//     });
//   }
//
//   loadTfliteModel() async {
//     try {
//       final interpreterOptions = InterpreterOptions();
//       interpreterOptions.threads = 4; // Adjust threads for performance
//       interpreter = await Interpreter.fromAsset('assets/model.tflite', options: interpreterOptions);
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading TFLite model: $e')));
//     }
//   }
//
//   loadLabels() async {
//
//     try {
//       String labelContent = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
//       emotionLabels = labelContent.split('\n'); // Split labels by newline
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading labels: $e')));
//     }
//   }
//
//   runModel() async {
//     if (cameraImage != null && interpreter != null) {
//
//       var input = cameraImage!.planes.map((plane) => plane.bytes).toList();
//
//       var outputTensors = interpreter!.getOutputTensors();
//
//       // Create output list with size based on output tensor shape
//       List<dynamic> outputList = (outputTensors[0].shape[1]) as dynamic;  // Assuming 1D scores
//
//       // Wait for model inference to complete
//       interpreter!.run(input, outputList);
//
//       // Assuming model outputs probabilities for each emotion
//       int mostLikelyEmotionIndex = outputList.indexOf(outputList.reduce((a, b) => a > b ? a : b));
//
//       // Ensure emotionLabels is loaded before accessing an index
//       if (mostLikelyEmotionIndex >= 0 && mostLikelyEmotionIndex < emotionLabels.length) {
//         String emotion = emotionLabels[mostLikelyEmotionIndex];
//         setState(() {
//           output = emotion;
//         });
//       } else {
//         print('Invalid emotion index: $mostLikelyEmotionIndex'); // Handle invalid index
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid emotion index: $mostLikelyEmotionIndex')));
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Live emotion detection'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: MediaQuery.of(context).size.width,
//               child: !cameraController!.value.isInitialized
//                   ? Container()
//                   : AspectRatio(
//                 aspectRatio: cameraController!.value.aspectRatio,
//                 child: CameraPreview(cameraController!),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             output,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
// }
