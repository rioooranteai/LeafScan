// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, unused_element, avoid_print, use_super_parameters, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../controllers/deteksi_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class DeteksiPenyakitView extends StatefulWidget {
  final DeteksiController controller;
  final List<CameraDescription> cameras; // Add cameras parameter

  DeteksiPenyakitView(
      {Key? key, required this.controller, required this.cameras})
      : super(key: key);

  @override
  _DeteksiPenyakitViewState createState() => _DeteksiPenyakitViewState();
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

class _DeteksiPenyakitViewState extends State<DeteksiPenyakitView> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  File? imageLeaf;

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
    if (_controller.value.hasError) {
      print(
          'Error saat menginisialisasi kamera: ${_controller.value.errorDescription}');
      // Anda juga dapat menambahkan dialog atau Snackbar untuk memberi tahu pengguna tentang error ini.
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

  Future<void> captureImage() async {
    if (_controller.value.isInitialized) {
      try {
        // Ambil gambar
        XFile file = await _controller.takePicture();
        print('Gambar diambil di: ${file.path}');

        // Crop gambar setelah diambil
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          compressQuality: 90,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              activeControlsWidgetColor: Color.fromARGB(255, 75, 196, 79),
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 75, 196, 79),
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPresetCustom(), // Gunakan custom preset
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPresetCustom(), // Gunakan custom preset
              ],
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        // Jika gambar telah dipotong, simpan ke imageLeaf
        if (croppedFile != null) {
          setState(() {
            imageLeaf = File(croppedFile.path);
          });
        }
      } catch (e) {
        print('Error saat mengambil gambar: $e');
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      print('Pemilihan gambar dibatalkan');
      return;
    }

    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 90,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              activeControlsWidgetColor: Color.fromARGB(255, 75, 196, 79),
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 75, 196, 79),
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPresetCustom(),
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
              ],
            ),
            WebUiSettings(
              context: context,
            ),
          ]);
      if (croppedFile != null) {
        setState(() {
          imageLeaf = File(croppedFile.path);
        });
      }
    } catch (e) {
      print('Error saat memotong gambar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Jika kamera telah diinisialisasi, tampilkan CameraPreview
          Positioned.fill(
            child: CameraPreview(_controller),
          ), // Tampilkan loader saat kamera belum siap
          Center(
            child: Image.asset(
              'assets/images/scan.png', // Ganti dengan path gambar logo kamu
              width: 400, // Atur ukuran gambar sesuai kebutuhan
              height: 400,
            ),
          ),
          // Logo LeafScan di bagian atas
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'LeafScan',
                style: GoogleFonts.alfaSlabOne(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),
          // Icon untuk histori deteksi di kanan atas
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.history, color: Colors.white, size: 30),
              onPressed: () {
                // Aksi untuk membuka histori deteksi
              },
            ),
          ),
          Positioned(
            bottom: 75,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ikon untuk memilih gambar dari galeri di sebelah kiri tombol "Detect Now"
                    IconButton(
                      icon: Icon(Icons.photo_library,
                          color: Colors.white, size: 30),
                      onPressed: pickImageFromGallery,
                    ),
                    SizedBox(width: 25),
                    // Tombol "Detect Now"
                    ElevatedButton(
                      onPressed: () {
                        // Capture and detect disease
                        captureImage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 239, 194, 33), // Warna tombol
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        "Ambil Gambar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
