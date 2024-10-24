// ignore_for_file: unused_element, unnecessary_late

import 'package:flutter/material.dart';
import 'Views/splash_screen_view.dart'; // Import splash screen
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
