import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Icon(Icons.info_outline, size: 64, color: Colors.amber[800]),
            SizedBox(height: 16),
            Text(
              'Klasifikasi Buah Pisang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber[900],
              ),
            ),
            Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),

            // About
            _buildCard(
              title: 'Tentang Aplikasi',
              child: Text(
                'Aplikasi untuk mengklasifikasikan tingkat kematangan buah pisang '
                'menggunakan machine learning. Membantu petani, pedagang, dan konsumen '
                'menentukan kualitas pisang secara cepat dan akurat.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[700]),
              ),
            ),

            SizedBox(height: 24),

            // Team
            _buildCard(
              title: 'Tim Pengembang',
              child: Column(
                children: [
                  _buildMember('Adhitya Fajar Al-Huda', '2309106027'),
                  Divider(height: 24),
                  _buildMember('Muhammad Aidil Saputra', '2309106042'),
                  Divider(height: 24),
                  _buildMember('Muhammad Rafif Hanif', '2309106044'),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Footer
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.school, color: Colors.amber[800], size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Universitas Mulawarman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                  Text(
                    'Informatika - 2024',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildMember(String name, String nim) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.amber[100],
          child: Icon(Icons.person, color: Colors.amber[800]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                nim,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}