// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, unused_element, avoid_print, use_super_parameters, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:leafscan/Views/riwayat_deteksi_view.dart';
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
  bool _isImageCropped = false;
  bool _isImageDetected = false;
  bool _isLoading = false;
  bool _isHealthy = false;
  bool _isNonLeafDetected = false;

  Future<void> viewResultDetected(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromARGB(
          255, 52, 121, 40), // Sesuaikan warna seperti pada gambar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Hasil Deteksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Divider(
                height: 2,
              ),
              SizedBox(height: 15),
              // Text(
              //   'Daun Sehat',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 20,
              //   ),
              // ),
              // Text(
              //   'Tidak terdeteksi adanya penyakit pada daun ini.',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16,
              //   ),
              // ),
              Text(
                'Penyakit Utama',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              ListTile(
                leading: Transform.rotate(
                  angle: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      width: 100, // lebar gambar
                      height: 100, // tinggi gambar
                      child: Image.asset(
                        'assets/images/blight.png',
                        fit: BoxFit.cover, // agar gambar pas di dalam kotak
                      ),
                    ),
                  ),
                ), // Gambar Similar 1
                title: Text('Hawar Daun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('Exserohilum turcicum',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              Text(
                'Lainnya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              ListTile(
                leading: Transform.rotate(
                  angle: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      width: 100, // lebar gambar
                      height: 100, // tinggi gambar
                      child: Image.asset(
                        'assets/images/gray.png',
                        fit: BoxFit.cover, // agar gambar pas di dalam kotak
                      ),
                    ),
                  ),
                ),
                title: Text('Bercak Daun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('Bipolaris maydis',
                    style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Transform.rotate(
                  angle: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      width: 100, // lebar gambar
                      height: 100, // tinggi gambar
                      child: Image.asset(
                        'assets/images/rust.png',
                        fit: BoxFit.cover, // agar gambar pas di dalam kotak
                      ),
                    ),
                  ),
                ), // Gambar Similar 2
                title: Text('Karat Daun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('Puccinia sorghi',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk simulasi proses deteksi
  Future<void> detectImage(BuildContext context) async {
    setState(() {
      _isLoading = true; // Menampilkan loading
    });

    // Simulasi proses deteksi (misalnya memanggil API)
    await Future.delayed(
        Duration(seconds: 5)); // Gantikan dengan logika deteksi yang sebenarnya

    setState(() {
      _isLoading = false; // Menyembunyikan loading setelah proses selesai
      _isImageDetected = true;
      _isNonLeafDetected = true;
    });

    if (!_isNonLeafDetected) {
      viewResultDetected(context);
    }
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  void initCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    try {
      await _controller.initialize();
    } catch (e) {
      print('Camera Error: $e');
      // Menampilkan snackbar untuk menunjukkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menginisialisasi kamera')),
      );
    }

    if (_controller.value.hasError) {
      print(
          'Error saat menginisialisasi kamera: ${_controller.value.errorDescription}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat menginisialisasi kamera')),
      );
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
            _isImageCropped = true;
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
          _isImageCropped = true;
        });
      }
    } catch (e) {
      print('Error saat memotong gambar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      body: Stack(
        children: [
          // Jika kamera telah diinisialisasi, tampilkan CameraPreview
          if (!_isImageCropped && _isCameraInitialized)
            Positioned.fill(
              child: CameraPreview(_controller),
            ),
          Center(
            child: _isImageDetected
                ? (_isHealthy
                    ? Image.file(
                        imageLeaf!, // Menampilkan gambar hasil deteksi (daun sehat)
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      )
                    : (_isNonLeafDetected
                        ? Image.asset(
                            'assets/images/notLeaf.png', // Gambar jika yang dideteksi bukan daun
                            width: 200,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'assets/images/multiple_disease.png', // Gambar jika ada penyakit
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          )))
                : (_isImageCropped && imageLeaf != null
                    ? Image.file(
                        imageLeaf!, // Menampilkan gambar yang sudah di-crop
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/images/scan.png', // Gambar default jika belum ada gambar
                        width: 400,
                        height: 400,
                      )),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RiwayatDeteksiView()),
                );
              },
            ),
          ),
          if (_isImageCropped) // Jika gambar sudah di-crop, tampilkan tombol Kembali di kanan atas
            Positioned(
              top: 60,
              left: 20, // Posisi untuk tombol kembali
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  // Reset state ketika kembali ke layar kamera
                  setState(() {
                    _isImageCropped = false;
                    imageLeaf = null; // Hapus gambar yang sudah di-crop
                    _isImageDetected = false;
                  });
                },
              ),
            ),
          if (!_isImageCropped) // Jika belum ada gambar yang dipilih, tampilkan tombol Pilih Gambar dan Ambil Gambar
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
                      IconButton(
                        icon: Icon(Icons.photo_library,
                            color: Colors.white, size: 30),
                        onPressed: pickImageFromGallery,
                      ),
                      SizedBox(width: 25),
                      ElevatedButton(
                        onPressed: captureImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 239, 194, 33),
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
          if (_isImageCropped &&
              !_isNonLeafDetected) // Jika gambar sudah di-crop, tampilkan tombol "Deteksi Sekarang"
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => detectImage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 239, 194, 33), // Warna kuning
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "Deteksi Sekarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          if (_isImageDetected &&
              !_isNonLeafDetected) // Jika gambar sudah di-crop, tampilkan tombol "Deteksi Sekarang"
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => viewResultDetected(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 239, 194, 33), // Warna kuning
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "Lihat Hasil Deteksi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          if (_isNonLeafDetected &&
              _isImageDetected) // Jika objek yang terdeteksi bukan daun
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Objek yang Dideteksi Bukan Daun\nSilakan Coba Lagi dengan Gambar Daun",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan aksi deteksi ulang
                      setState(() {
                        _isImageCropped = false;
                        imageLeaf = null; // Hapus gambar yang sudah di-crop
                        _isImageDetected = false;
                        _isNonLeafDetected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 239, 194, 33), // Warna kuning
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Tampilan loading ketika proses deteksi sedang berjalan
          if (_isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Efek blur
                child: Container(
                  color:
                      Colors.black.withOpacity(0.2), // Warna semi-transparent
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 8, // Perbesar ukuran loading
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
