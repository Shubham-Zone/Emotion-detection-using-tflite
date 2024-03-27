import 'package:camera/camera.dart';
import 'package:emotion_detection/EmotionDetection.dart';
import 'package:emotion_detection/Provider/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'EmoDetect.dart';
import 'Provider/DataModel.dart';
import 'firebase_options.dart';

List<CameraDescription>? cameras;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child:  MaterialApp(
        title: "Emotion detection",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepOrange
        ),
        home:const EmotionDetection(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    final apiCall = Provider.of<ApiProvider>(context);
    apiCall.storeDataToList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emotion detection"),
      ),
      body: FutureBuilder<List<Data>>(
        future: apiCall.futureData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: snapshot.data!.map((data) => Card(
                    elevation: 20,
                    shadowColor: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(data.avatar),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("id: ${data.id.toString()}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("First name: ${data.firstName}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Last name: ${data.lastName}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("email: ${data.email}"),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            );

          }
          else if(snapshot.hasError){
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }

          // By default show a circular spinner
          return const CircularProgressIndicator();
        },
      )
    );
  }
}

