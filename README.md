# Technical Documentation - Deteksi Penyakit Daun Jagung Menggunakan YOLO

### 1. Ringkasan
Dokumen ini menjelaskan proyek pengembangan aplikasi berbasis mobile untuk mendeteksi penyakit pada daun jagung menggunakan teknologi deteksi objek YOLO (You Only Look Once). Aplikasi ini bertujuan membantu petani dan pemangku kepentingan di sektor pertanian dalam identifikasi dini dan penanganan penyakit daun jagung, sehingga meningkatkan kesehatan tanaman dan hasil panen. Proyek ini berupaya menghadirkan alat diagnostik yang mudah diakses, efisien, dan andal untuk perangkat mobile.

### 2. Motivasi
Jagung adalah salah satu tanaman pangan utama secara global. Menurut data yang diperoleh dari Badan Pusat Statistik, jumlah panen jagung di Indonesia adalah sebesar 14,46 juta ton pada tahun 2023. Namun, produktivitasnya sering terhambat oleh penyakit yang menyerang daunnya. Deteksi dini terhadap penyakit ini dapat mencegah kerugian besar dan mengurangi ketergantungan pada ahli untuk diagnosis. Dengan semakin banyaknya penggunaan smartphone, solusi berbasis mobile dapat memberdayakan petani dan profesional pertanian untuk mengambil langkah proaktif dengan biaya dan usaha yang minimal. Bukan hanya itu, petani juga dapat mendapatkan metode terbaru dalam menangani setiap penyakit yang berhasil didiagnosis.

### 3. Metode Keberhasilan
- **Akurasi deteksi**: Mencapai setidaknya 90% presisi dan recall pada dataset uji.
- **Performa**: Memastikan waktu inferensi per gambar kurang dari 30 detik pada perangkat mobile.

### 4. Persyaratan & Kendala
#### Persyaratan Fungsional
- Kemampuan untuk mengambil atau mengunggah gambar daun jagung untuk analisis.
- Deteksi penyakit secara real-time dengan umpan balik rinci pada masalah yang teridentifikasi.
- Memberikan rekomendasi tindakan untuk menangani penyakit yang terdeteksi.
- Mendukung bahasa Indonesia untuk aksesibilitas yang lebih luas.

#### Kendala
- Ukuran model harus di bawah 50 MB untuk memastikan performa yang efisien di perangkat mobile.
- Latensi tidak boleh melebihi 1 detik per gambar untuk kenyamanan pengguna.
- Peluncuran awal dibatasi pada tiga penyakit utama daun jagung: **Common Rust**, **Gray Leaf Spot (GLS)**, dan **Blight**.

#### Ruang Lingkup
- **Dalam Ruang Lingkup**: Deteksi penyakit untuk daftar penyakit daun jagung yang telah ditentukan sebelumnya. Pengembangan platform mobile (iOS dan Android).
- **Di Luar Ruang Lingkup**: Deteksi umum penyakit atau hama tanaman lainnya. Aplikasi berbasis desktop atau web.

### 5. Metodologi
#### 5.1. Pernyataan Masalah
Mendeteksi penyakit daun jagung melalui teknik deteksi objek, memungkinkan identifikasi otomatis dan akurat melalui perangkat mobile.

#### 5.2. Data
- **Data Pelatihan**: Dataset Kaggle "Corn or Maize Leaf Disease Dataset" dengan distribusi:  
  - Common Rust: 1306 gambar  
  - Gray Leaf Spot: 574 gambar  
  - Blight: 1146 gambar  
  - Healthy: 1162 gambar  
- **Data Input**: Gambar yang diambil melalui kamera ponsel atau diunggah oleh pengguna.
- Sumber data meliputi dataset publik, makalah penelitian, dan kemitraan dengan lembaga pertanian.
- **Pengelolaan Data**: Data yang diunggah pengguna akan dilabeli ulang untuk melatih model baru secara berkala agar data terus up-to-date.

#### 5.3. Teknik
- Menggunakan YOLOv8S untuk deteksi objek secara real-time.
- Menggunakan SAHI untuk inferensi sehingga model mampu untuk mendeteksi gambar penyakit yang ukurannya sangat kecil.
- Melakukan pra-pemrosesan data dengan teknik augmentasi seperti auto-orient, resize 640 x 640, penyesuaian warna, saturasi, kecerahan, pencahayaan, blur, dan Bounding Box Flip.
- Menggunakan API OPENAI untuk menghasilkan teks rekomendasi penyembuhan berdasarkan hasil deteksi penyakit.

#### 5.4. Eksperimen & Validasi
- Menggunakan presisi, recall, dan F1-score sebagai metrik utama untuk validasi offline.
- Melakukan uji coba di lingkungan terkendali untuk menilai kinerja di dunia nyata.

### 6. Implementasi
#### 6.1. Desain Tingkat Tinggi
- Aplikasi mobile berinteraksi dengan mesin deteksi berbasis YOLO.
- Opsi inferensi offline menggunakan model yang tersemat.

#### 6.2. Infrastruktur
- Model dan layanan pendukung di-host pada VM Google Cloud Platform (GCP) menggunakan backend berbasis FastAPI.

#### 6.3. Keamanan
- Mengautentikasi pengguna melalui mekanisme login yang aman menggunakan Firebase.

#### 6.4. Pemantauan & Alarm
- Mencatat metrik penggunaan aplikasi dan data performa model.
- Menyiapkan peringatan untuk tingkat kesalahan yang melebihi 5% atau gangguan layanan.

#### 6.5. Biaya
- Biaya tambahan sekitar Rp200.000 untuk langganan Colab PRO untuk pelatihan model. Biaya ini diperlukan untuk mengakses GPU A100 agar proses training data bisa berjalan dengan lebih cepat.

## **Dokumentasi MVP**

