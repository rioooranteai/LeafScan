// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../controllers/deteksi_controller.dart';

class DeteksiPenyakitView extends StatefulWidget {
  final DeteksiController controller;

  DeteksiPenyakitView({Key? key, required this.controller}) : super(key: key);

  @override
  _DeteksiPenyakitViewState createState() => _DeteksiPenyakitViewState();
}

class _DeteksiPenyakitViewState extends State<DeteksiPenyakitView> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      _cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          isCameraInitialized = true;
        });
      });
    }
  }

  Future<void> captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      setState(() {
        imagePath = image.path;
      });
      // Send the image to the controller for detection
      widget.controller.deteksiPenyakit(imagePath!);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isCameraInitialized)
            CameraPreview(_cameraController!)
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Capture and detect disease
                    captureImage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Button color
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "Detect Now",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
