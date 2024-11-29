// ignore_for_file: prefer_const_constructors, use_super_parameters, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafscan/Views/rekomendasi_view.dart';

class RiwayatDeteksiView extends StatefulWidget {
  @override
  _RiwayatDeteksiViewState createState() => _RiwayatDeteksiViewState();
}

class _RiwayatDeteksiViewState extends State<RiwayatDeteksiView> {
  List<Map<String, dynamic>> diseases = [];
  bool isLoading = true;

  Map<String, String> latinNames = {
    'blight': 'Exserohilium turcicium',
    'gray': 'Bipolaris maydis',
    'rust': 'Puccinia sorghi',
  };

  Map<String, String> indonesian = {
    'blight': 'Hawar Daun',
    'gray': 'Bercak Daun',
    'rust': 'Karat Daun',
  };

  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email!.replaceAll('.', '_');
      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userEmail)
          .child('diseases');

      final snapshot = await ref.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> fetchedDiseases = [];
        snapshot.children.forEach((disease) {
          fetchedDiseases.add(Map<String, dynamic>.from(disease.value as Map));
        });
        setState(() {
          diseases = fetchedDiseases;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
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
            ),
            // ListView
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : diseases.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada riwayat deteksi.',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: diseases.length,
                          itemBuilder: (context, index) {
                            var disease = diseases[index];
                            DateTime parsedDate =
                                DateTime.parse(disease['timestamp']);
                            String formattedDate =
                                '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RekomendasiView(disease: disease),
                                  ),
                                );
                              },
                              child: HistoryCard(
                                imageUrl:
                                    base64Decode(disease['predicted_image']),
                                diseaseName:
                                    indonesian[disease['disease_name']] ??
                                        'Nama latin tidak tersedia',
                                diseaseType:
                                    latinNames[disease['disease_name']] ??
                                        'Nama latin tidak tersedia',
                                detectedDate:
                                    'Tanggal Deteksi ${formattedDate}',
                              ),
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
  final Uint8List imageUrl;
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
              child: Image.memory(
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
              mainAxisAlignment: MainAxisAlignment.end,
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
