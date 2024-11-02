// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafscan/Views/login_view.dart';

class RegisterView extends StatefulWidget {
  final List<CameraDescription> cameras;

  RegisterView({required this.cameras});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    // final username = _usernameController.text;
    // final password = _passwordController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginView(
                cameras: widget.cameras,
              )),
    );

    // if (username.isNotEmpty && password.isNotEmpty) {
    //   // Simulate account creation and navigate back to login screen
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Akun berhasil dibuat! Silakan login.'),
    //       backgroundColor: Color.fromARGB(255, 52, 121, 40),
    //     ),
    //   );

    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginView()),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Username dan Password tidak boleh kosong!'),
    //       backgroundColor: Color.fromARGB(255, 52, 121, 40),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
              SizedBox(height: 80),
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
                  'Register',
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
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
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

              // Tombol register
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color.fromARGB(255, 52, 121, 40),
                  ),
                  child: Text(
                    'Daftar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Navigasi ke halaman login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginView(cameras: widget.cameras)),
                      );
                    },
                    child: Text(
                      "Login",
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
