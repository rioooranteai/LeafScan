// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatDeteksiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 60.0),
        child: Column(
          children: [
            // Header
            Container(
              color: Color.fromARGB(255, 52, 121, 40),
              height: 60,
              child: Column(
                children: [
                  Row(
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
                        'History',
                        style: GoogleFonts.alfaSlabOne(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 40), // Placeholder for alignment
                    ],
                  ),
                ],
              ),
            ),
            // Positioned ListView
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return HistoryCard(
                    imageUrl:
                        'assets/images/multiple_disease.png', // Change this to the correct path
                    diseaseName: 'Bercak Cokelat pada Jagung',
                    diseaseType: 'Physoderma maydis',
                    detectedDate: 'Tanggal Deteksi 26/09/2024',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String imageUrl;
  final String diseaseName;
  final String diseaseType;
  final String detectedDate;

  const HistoryCard({
    Key? key,
    required this.imageUrl,
    required this.diseaseName,
    required this.diseaseType,
    required this.detectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              diseaseName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              diseaseType,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Aligns the date to the right
              children: [
                Text(
                  detectedDate,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
