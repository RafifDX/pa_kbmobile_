import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: const Text(
          'Tutorial Penggunaan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Icon(Icons.help_outline, size: 64, color: Colors.amber[800]),
            SizedBox(height: 16),
            Text(
              'Cara Menggunakan Aplikasi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber[900],
              ),
            ),
            Text(
              'Ikuti langkah-langkah berikut',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),

            // Steps
            _buildStep(
              number: '1',
              title: 'Buka Halaman Scan',
              description: 'Ketuk tombol "Scan Pisang" di bagian bawah halaman utama.',
            ),
            SizedBox(height: 16),
            _buildStep(
              number: '2',
              title: 'Upload Foto Pisang',
              description: 'Pilih foto dari galeri atau ambil foto dengan kamera.',
            ),
            SizedBox(height: 16),
            _buildStep(
              number: '3',
              title: 'Tunggu Proses Analisis',
              description: 'Aplikasi akan menganalisis tingkat kematangan pisang.',
            ),
            SizedBox(height: 16),
            _buildStep(
              number: '4',
              title: 'Lihat Hasil',
              description: 'Hasil klasifikasi akan ditampilkan beserta rekomendasinya.',
            ),

            SizedBox(height: 32),

            // Tips
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber[800], size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan pencahayaan cukup dan pisang terlihat jelas!',
                      style: TextStyle(fontSize: 14, color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/scan');
                },
                icon: Icon(Icons.camera_alt),
                label: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Mulai Scan Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}