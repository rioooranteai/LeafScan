// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafscan/Service/auth.dart';
import 'package:leafscan/Views/deteksi_penyakit_view.dart';
import 'package:leafscan/Views/login_view.dart';

class SplashScreenView extends StatefulWidget {
  final List<CameraDescription> cameras; // Tambahkan parameter cameras

  SplashScreenView({required this.cameras}); // Update constructor

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    // Mengatur waktu delay splash screen
    Future.delayed(Duration(seconds: 3), () {
      final auth = Auth();
      if (auth.currentUser != null) {
        // Jika pengguna sudah login, pindah ke DeteksiPenyakitView
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeteksiPenyakitView(
              cameras: widget.cameras,
            ),
          ),
        );
      } else {
        // Jika belum login, pindah ke LoginView
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(
              cameras: widget.cameras,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
          0xFFF5F3E8), // Warna background sesuai dengan splash screen (beige muda)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gambar logo
            Image.asset(
              'assets/images/logo_leafscan.png', // Ganti dengan path gambar logo kamu
              width: 250, // Atur ukuran gambar sesuai kebutuhan
              height: 250,
            ),
            SizedBox(
              height: 20,
            ),
            // Nama aplikasi
            Text(
              'LeafScan',
              style: GoogleFonts.alfaSlabOne(
                textStyle: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 52, 121, 40),
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
