// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../controllers/deteksi_controller.dart';

class DeteksiPenyakitView extends StatefulWidget {
  final DeteksiController controller;
  final List<CameraDescription> cameras; // Add cameras parameter

  DeteksiPenyakitView(
      {Key? key, required this.controller, required this.cameras})
      : super(key: key);

  @override
  _DeteksiPenyakitViewState createState() => _DeteksiPenyakitViewState();
}

class _DeteksiPenyakitViewState extends State<DeteksiPenyakitView> {
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  initCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    try {
      await _controller.initialize();
    } catch (e) {
      print('Camera Error: $e');
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Jika kamera telah diinisialisasi, tampilkan CameraPreview
          Positioned.fill(
            child: CameraPreview(_controller),
          ), // Tampilkan loader saat kamera belum siap
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
