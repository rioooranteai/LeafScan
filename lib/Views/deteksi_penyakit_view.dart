// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, unused_element, avoid_print, use_super_parameters, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, dead_code, duplicate_ignore

import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:leafscan/Service/auth.dart';
import 'package:leafscan/Views/login_view.dart';
import 'package:leafscan/Views/rekomendasi_view.dart';
import 'package:leafscan/Views/riwayat_deteksi_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DeteksiPenyakitView extends StatefulWidget {
  final List<CameraDescription> cameras; // Add cameras parameter

  DeteksiPenyakitView({Key? key, required this.cameras}) : super(key: key);

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
  User? user;
  List<String> diseaseNames = [];
  late Uint8List bytesPredictedImage;

  Map<String, dynamic> grayDisease = {};
  Map<String, dynamic> rustDisease = {};
  Map<String, dynamic> blightDisease = {};

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
              if (_isHealthy) ...[
                // Display healthy status
                Text(
                  'Daun Sehat',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Tidak terdeteksi adanya penyakit pada daun ini.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ] else ...[
                if (diseaseNames.contains('Hawar Daun')) ...[
                  ListTile(
                    leading: Transform.rotate(
                      angle: 0,
                      child: Container(
                        width: 100, // width of the image
                        height: 100, // height of the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              5.0), // Rounded corners for the border
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                5.0), // Match the border radius
                            child: Image.memory(
                              bytesPredictedImage,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    title: Text(
                      'Hawar Daun',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Exserohilium turcicium',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RekomendasiView(
                            disease: blightDisease,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                if (diseaseNames.contains('Bercak Daun')) ...[
                  ListTile(
                    leading: Transform.rotate(
                      angle: 0,
                      child: Container(
                        width: 100, // width of the image
                        height: 100, // height of the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              5.0), // Rounded corners for the border
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              5.0), // Match the border radius
                          child: Image.memory(
                            bytesPredictedImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Bercak Daun',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Bipolaris maydis',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RekomendasiView(
                            disease: grayDisease,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                if (diseaseNames.contains('Karat Daun')) ...[
                  ListTile(
                    leading: Transform.rotate(
                      angle: 0,
                      child: Container(
                        width: 100, // width of the image
                        height: 100, // height of the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              5.0), // Rounded corners for the border
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              5.0), // Match the border radius
                          child: Image.memory(
                            bytesPredictedImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Karat Daun',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Puccinia sorghi',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RekomendasiView(
                            disease: rustDisease,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Future<Uint8List?> convertImageToJpegOrPng(File imageFile,
      {bool isJpeg = true}) async {
    // Mengonversi gambar ke format JPEG atau PNG
    final format = isJpeg ? CompressFormat.jpeg : CompressFormat.png;

    final result = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      format: format,
      quality: 80, // Atur kualitas sesuai kebutuhan
    );
    return result;
  }

  // Fungsi untuk simulasi proses deteksi
  Future<void> detectImage(BuildContext context) async {
    setState(() {
      _isLoading = true; // Menampilkan loading
    });

    String userUID = user?.email ?? "guest@gmail.com";

    // Simulasi proses deteksi (misalnya memanggil API)
    // Membuat request POST ke API
    final uri = Uri.parse("http://35.198.229.84:8000/predict-image");

    print("test");

    // Pilih apakah mengonversi ke JPEG atau PNG
    bool isJpeg = true; // Atur menjadi false jika ingin mengonversi ke PNG
    Uint8List? imageBytes =
        await convertImageToJpegOrPng(imageLeaf!, isJpeg: isJpeg);

    if (imageBytes != null) {
      print("test2");
      // Membuat request multipart untuk mengirim gambar
      var request = http.MultipartRequest('POST', uri)
        ..fields['username'] = userUID // Menggunakan email sebagai UID
        ..files.add(http.MultipartFile(
          'image', // Sesuaikan dengan parameter API
          Stream.fromIterable([imageBytes]),
          imageBytes.length,
          filename: isJpeg
              ? 'image.jpg'
              // ignore: dead_code
              : 'image.png', // Tentukan nama file berdasarkan format
          contentType:
              isJpeg ? MediaType('image', 'jpeg') : MediaType('image', 'png'),
        ));

      try {
        // Kirim request ke server
        print("test3");
        final response = await request.send();

        if (response.statusCode == 200) {
          // Berhasil mendapatkan response, misalnya dengan menggunakan stream untuk membaca response body
          final responseData = await response.stream.bytesToString();

          // Proses hasil deteksi
          print("Hasil Deteksi: $responseData");

          //simpan data
          // Parsing JSON responseData ke dalam Map
          final Map<String, dynamic> responseJson = jsonDecode(responseData);

          print("coba coba coba $responseJson");
          String predictedImage = responseJson['predicted-image'];
          bytesPredictedImage = base64Decode(predictedImage);

          print(responseJson['predicted-image']);

          bool isCorn = responseJson['iscorn'];
          print(isCorn);
          String timestamp = responseJson['timestamp'];
          print(timestamp);

          // Menyimpan disease ke dalam list
          List<Map<String, dynamic>> diseases = [];
          Map<String, dynamic> diseaseData = responseJson['disease'];
          print(diseaseData);

          // Mapping nama penyakit lama ke nama baru
          Map<String, String> diseaseNameMapping = {
            "gray": "Bercak Daun",
            "rust": "Karat Daun",
            "blight": "Hawar Daun"
          };

          for (String key in diseaseData.keys) {
            // Menggunakan mapping untuk mengganti nama penyakit
            diseaseNames.add(diseaseNameMapping[key] ??
                key); // Jika tidak ada mapping, tetap gunakan nama asli
          }

          for (String key in diseaseData.keys) {
            diseases.add({
              "name": key,
              "definisi_penyakit": diseaseData[key]['Definisi'],
              "predicted_image": base64Decode(predictedImage),
              "diagnosa": diseaseData[key]['Diagnosa'],
              "saran": diseaseData[key]['Saran'],
              "timestamp": timestamp
            });

            Map<String, dynamic> diseaseEntry = {
              "disease_name": key,
              "definisi_penyakit": diseaseData[key]['Definisi'],
              "predicted_image": predictedImage,
              "diagnosa": diseaseData[key]['Diagnosa'],
              "saran": diseaseData[key]['Saran'],
              "timestamp": timestamp
            };

            // Menyimpan penyakit berdasarkan jenisnya
            if (key == "gray") {
              grayDisease = diseaseEntry;
            } else if (key == "rust") {
              rustDisease = diseaseEntry;
            } else if (key == "blight") {
              blightDisease = diseaseEntry;
            } else {
              print("Penyakit tidak dikenal: $key");
            }
          }

          print(diseases);

          // simpan ke firebase realtime database
          String userEmail = user!.email!.replaceAll('.', '_');
          final databaseReference = FirebaseDatabase.instance.ref();

          // Menyimpan setiap disease ke database di bawah email user
          for (var disease in diseases) {
            String diseaseName = disease['name'];
            Map<String, dynamic> diseaseDetails = {
              'predicted_image': base64Encode(disease['predicted_image']),
              "definisi_penyakit": disease['definisi_penyakit'],
              'diagnosa': disease['diagnosa'],
              'saran': disease['saran'],
              'timestamp': disease['timestamp'],
              'disease_name':
                  diseaseName, // Untuk menampilkan nama penyakit di list nantinya
            };

            print("disease details");
            print(disease['definisi_penyakit']);

            // Menggunakan push() untuk membuat ID unik untuk penyakit
            await databaseReference
                .child('users')
                .child(userEmail)
                .child('diseases')
                .push()
                .set(diseaseDetails);
          }

          setState(() {
            _isLoading = false;
            _isImageDetected = true; // Mengubah status menjadi image detected
            //disini taruh perkondisian (ada penyakit, tidak ada penyakit dan bukan daun)
            _isNonLeafDetected = !isCorn;
            _isHealthy = diseaseData.isEmpty;
          });

          // Tampilkan hasil deteksi (misalnya dialog atau layar baru)
          viewResultDetected(context);
        } else {
          // Jika gagal menghubungi API
          setState(() {
            _isLoading = false;
          });
          // Mengambil detail error dari response body
          final errorData = await response.stream.bytesToString();
          print("Error Data: $errorData");
          showErrorDialog(context, errorData);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Hasil: $e");
        // Tangani kesalahan jika terjadi
        showErrorDialog(context, "Terjadi kesalahan: $e");
      }
    } else {
      print("Gagal mengonversi gambar.");
      _isLoading = false;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    initCamera();
    Firebase.initializeApp();
    user = FirebaseAuth.instance.currentUser;
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
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0), // Add margin as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the desired corner radius
                          border: Border.all(
                            color: Colors.white, // Border color (optional)
                            width: 3, // Border width (optional)
                          ),
                          boxShadow: [
                            // Optional shadow for better visibility
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: Offset(0, 3), // Offset for shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          // Use ClipRRect for rounded corners
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the same radius as above
                          child: Image.file(
                            imageLeaf!, // Replace with the actual asset path
                            width: 350, // Set the width of the image
                            fit: BoxFit.contain, // Adjust the fit as needed
                          ),
                        ),
                      )
                    : (_isNonLeafDetected
                        ? Image.asset(
                            'assets/images/notLeaf.png', // Gambar jika yang dideteksi bukan daun
                            width: 200,
                            fit: BoxFit.contain,
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0), // Add margin as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the desired corner radius
                              border: Border.all(
                                color: Colors.white, // Border color (optional)
                                width: 3, // Border width (optional)
                              ),
                              boxShadow: [
                                // Optional shadow for better visibility
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: Offset(0, 3), // Offset for shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                                // Use ClipRRect for rounded corners
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set the same radius as above
                                child: Image.memory(
                                  bytesPredictedImage,
                                  width: 350,
                                  fit: BoxFit.contain,
                                )),
                          )))
                : (_isImageCropped && imageLeaf != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0), // Add margin as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the desired corner radius
                          border: Border.all(
                            color: Colors.white, // Border color (optional)
                            width: 3, // Border width (optional)
                          ),
                          boxShadow: [
                            // Optional shadow for better visibility
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: Offset(0, 3), // Offset for shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          // Use ClipRRect for rounded corners
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the same radius as above
                          child: Image.file(
                            imageLeaf!, // Replace with the actual asset path
                            width: 350, // Set the width of the image
                            fit: BoxFit.contain, // Adjust the fit as needed
                          ),
                        ),
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
          Visibility(
            visible: !_isImageCropped,
            child: Positioned(
              top: 60,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.history, color: Colors.white, size: 30),
                onPressed: () {
                  // Aksi untuk membuka histori deteksi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiwayatDeteksiView()),
                  );
                },
              ),
            ),
          ),
          // Icon for logout on the top right
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white, size: 30),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 52, 121, 40),
                      title: Text(
                        'Konfirmasi Logout',
                        style: TextStyle(
                            fontSize: 20, // Font size for title
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      content: Text(
                        'Apakah Anda yakin ingin logout?',
                        style: TextStyle(
                            fontSize: 16, // Font size for content
                            color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Tidak',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16, // Font size for "Tidak" button
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Confirm logout, sign out, and navigate to LoginView
                            Navigator.of(context)
                                .pop(); // Close the dialog first
                            await Auth().signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginView(cameras: widget.cameras)),
                            );
                          },
                          child: Text(
                            'Ya',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16, // Font size for "Ya" button
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
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
                    _isHealthy = false;
                    _isNonLeafDetected = false;
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
