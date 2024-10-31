// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RekomendasiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      body: Column(
        children: [
          // Header with Padding
          Padding(
            padding: const EdgeInsets.only(
                top: 50.0), // Adjust the top padding as needed
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
                        Text('Detail Penyakit',
                            style: GoogleFonts.alfaSlabOne(
                              textStyle: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2),
                            )),
                        SizedBox(width: 40), // Placeholder for alignment
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Recommendation Widget
          Expanded(
            child: Recommendation(),
          ),
        ],
      ),
    );
  }
}

class Recommendation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
        child: Column(
          children: [
            // Centered Disease Name and Scientific Name
            Text(
              'Bercak Daun',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Bipolaris maydis',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10), // Spacing below the title
            Container(
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
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: ClipRRect(
                // Use ClipRRect for rounded corners
                borderRadius:
                    BorderRadius.circular(20.0), // Set the same radius as above
                child: Image.asset(
                  'assets/images/multiple_disease.png', // Replace with the actual asset path
                  height: 300, // Set the height of the image as needed
                  width: 300, // Set the width of the image as needed
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),

            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ), // Change divider color here
              child: ExpansionTile(
                title: Text(
                  'Deskripsi Penyakit',
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
                    padding: const EdgeInsets.only(
                        bottom: 20.0, right: 15.0, left: 15.0, top: 15.0),
                    child: Text(
                      'Infeksi menyebabkan bintik-bintik kecil berwarna kuning hingga coklat pada daun, batang, pelepah dan kulit jagung. Ketika penyakit ini berkembang, bintik-bintik membesar dan meluas. Bercak atau pita yang dihasilkan dapat menutupi sebagian daun. Warna biasanya bervariasi dari kekuningan hingga coklat, menyerupai gejala yang ditimbulkan oleh beberapa jenis penyakit karat.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  'Apa Penyebabnya?',
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
                    padding: const EdgeInsets.only(
                        bottom: 20.0, right: 15.0, left: 15.0, top: 15.0),
                    child: Text(
                      'Gejala disebabkan oleh Physoderma maydis, jamur yang melewati musim dingin di sisa-sisa tanaman yang terinfeksi atau di tanah (hingga 7 tahun dalam kondisi yang mendukung). Penyakit ini lebih umum di lahan yang ditanami jagung secara terus-menerus atau lahan dengan sisa-sisa tanaman yang berlimpah, misalnya di mana kebiasaan pengolahan tanah kurang dilakukan.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  'Rekomendasi Pengendalian',
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
                    padding: const EdgeInsets.only(
                        bottom: 20.0, right: 15.0, left: 15.0, top: 15.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text:
                                'Pengendalian Hayati dan Budidaya Tanaman\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '1. Rotasi Tanaman: Lakukan rotasi tanaman dengan jenis tanaman yang bukan inang P. maydis untuk memutus siklus hidup patogen.\n',
                          ),
                          TextSpan(
                            text:
                                '2. Pembersihan Lahan: Bersihkan lahan dari sisa-sisa tanaman jagung yang terinfeksi dan musnahkan untuk mengurangi sumber penyakit di musim berikutnya.\n',
                          ),
                          TextSpan(
                            text:
                                '3. Penggunaan Bibit Tahan Penyakit: Gunakan bibit jagung yang tahan penyakit untuk mengurangi risiko infeksi.\n\n',
                          ),
                          TextSpan(
                            text: 'Pengelolaan Lingkungan Tanam\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '1. Jarak Tanam: Pastikan jarak tanam cukup untuk sirkulasi udara yang baik, mengurangi kelembapan yang berpotensi mendukung perkembangan jamur.\n',
                          ),
                          TextSpan(
                            text:
                                '2. Penyiraman: Hindari penyiraman berlebihan di daerah yang terinfeksi untuk mengurangi kelembapan pada daun dan batang.\n\n',
                          ),
                          TextSpan(
                            text: 'Pemantauan Tanaman Secara Berkala\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Lakukan pemeriksaan rutin untuk mendeteksi gejala dini penyakit pada daun. Segera tangani bagian yang terinfeksi agar penyakit tidak menyebar ke seluruh tanaman.\n\n',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
