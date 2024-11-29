// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RekomendasiView extends StatelessWidget {
  final Map<String, dynamic> disease;

  RekomendasiView({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      body: Column(
        children: [
          // Header with Padding
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              color: Color.fromARGB(255, 52, 121, 40),
              height: 55,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Detail Penyakit',
                          style: GoogleFonts.alfaSlabOne(
                            textStyle: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Recommendation Widget
          Expanded(
            child: Recommendation(
              disease: disease,
            ),
          ),
        ],
      ),
    );
  }
}

class Recommendation extends StatelessWidget {
  final Map<String, dynamic> disease;

  Recommendation({required this.disease});

  @override
  Widget build(BuildContext context) {
    final String diseaseName = disease["disease_name"] ?? "Nama tidak tersedia";
    final String description =
        disease["definisi_penyakit"] ?? "Deskripsi tidak tersedia";
    final String diagnosis = disease["diagnosa"] ?? "Diagnosa tidak tersedia";
    final String recommendation = disease["saran"] ?? "Saran tidak tersedia";

    // Pastikan predicted_image di-decode hanya jika tidak null.
    final Uint8List? predictedImage = disease["predicted_image"] != null
        ? base64Decode(disease["predicted_image"])
        : null;

    String _getIndonesianName(String diseaseName) {
      if (diseaseName.toLowerCase().contains("blight")) {
        return "Hawar Daun";
      } else if (diseaseName.toLowerCase().contains("gray")) {
        return "Bercak Daun";
      } else if (diseaseName.toLowerCase().contains("rust")) {
        return "Karat Daun";
      } else {
        return "Nama Ilmiah Tidak Diketahui";
      }
    }

    String _getScientificName(String diseaseName) {
      if (diseaseName.toLowerCase().contains("blight")) {
        return "Exserohilum turcicum";
      } else if (diseaseName.toLowerCase().contains("gray")) {
        return "Bipolaris maydis";
      } else if (diseaseName.toLowerCase().contains("rust")) {
        return "Puccinia sorghi";
      } else {
        return "Nama Ilmiah Tidak Diketahui";
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
        child: Column(
          children: [
            // Displaying Disease Name
            Text(
              _getIndonesianName(diseaseName),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              _getScientificName(diseaseName), //nama ilmiah
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Displaying Predicted Image
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.memory(
                  predictedImage!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Expansion Tiles
            _buildExpansionTile(context, "Deskripsi Penyakit", description),
            _buildExpansionTile(context, "Diagnosa", diagnosis),
            _buildExpansionTile(context, "Saran", recommendation),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
      BuildContext context, String title, String content) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        textColor: Colors.white,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              content,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
