// ignore_for_file: unused_element, unnecessary_late, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:leafscan/Service/firebase_options.dart';
import 'Views/splash_screen_view.dart'; // Import splash screen
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';

late List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LeafScan',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashScreenView(
            cameras: _cameras), // Set SplashScreen sebagai halaman pertama
        debugShowCheckedModeBanner: false);
  }
}
