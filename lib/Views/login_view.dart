// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafscan/Service/auth.dart';
import 'package:leafscan/Views/deteksi_penyakit_view.dart';
import 'package:leafscan/Views/register_view.dart';

class LoginView extends StatefulWidget {
  final List<CameraDescription> cameras;

  LoginView({required this.cameras});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final auth = Auth();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Navigate to the DeteksiPenyakitView after successful login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DeteksiPenyakitView(
              cameras: widget.cameras,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        // Show an error message if sign-in fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
          ),
        );
      }
    } else {
      // Show error if username or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username dan Password tidak boleh kosong!'),
          backgroundColor: Color.fromARGB(255, 52, 121, 40),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3E8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80), // Spacer to center content vertically
              // Gambar logo
              Image.asset(
                'assets/images/logo_leafscan.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              // Nama aplikasi
              Text(
                'LeafScan',
                style: GoogleFonts.alfaSlabOne(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 52, 121, 40),
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Teks "REGISTER" aligned left
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 52, 121, 40),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Input username
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Input password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Tombol login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color.fromARGB(255, 52, 121, 40),
                  ),
                  child: Text(
                    'Masuk',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Navigasi ke halaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterView(
                                  cameras: widget.cameras,
                                )),
                      );
                    },
                    child: Text(
                      "Daftar sekarang",
                      style: TextStyle(
                          color: Color.fromARGB(255, 52, 121, 40),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40), // Extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
