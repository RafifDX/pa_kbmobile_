import 'dart:typed_data';
import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String hasil;
  final double? confidence;

  const ScanResultPage({
    super.key,
    required this.imageBytes,
    required this.hasil,
    this.confidence,
  });

  // Get color based on classification
  Color _getResultColor(String result) {
    final lowerResult = result.toLowerCase();
    if (lowerResult.contains('mentah')) return Colors.green;
    if (lowerResult.contains('matang') && !lowerResult.contains('terlalu')) {
      return Colors.amber;
    }
    if (lowerResult.contains('terlalu') || lowerResult.contains('kematangan')) {
      return Colors.orange;
    }
    if (lowerResult.contains('busuk')) return Colors.brown;
    return Colors.grey;
  }

  // Get icon based on classification
  IconData _getResultIcon(String result) {
    final lowerResult = result.toLowerCase();
    if (lowerResult.contains('mentah')) return Icons.eco;
    if (lowerResult.contains('matang')) return Icons.star;
    if (lowerResult.contains('busuk')) return Icons.warning;
    return Icons.info;
  }

  // Get description based on classification
  String _getDescription(String result) {
    final lowerResult = result.toLowerCase();
    if (lowerResult.contains('mentah')) {
      return 'Pisang masih hijau dan keras. Belum siap dikonsumsi langsung. Cocok untuk digoreng atau direbus.';
    }
    if (lowerResult.contains('matang') && !lowerResult.contains('terlalu')) {
      return 'Pisang sudah matang sempurna! Warna kuning merata dan siap dikonsumsi. Rasa manis optimal.';
    }
    if (lowerResult.contains('terlalu') || lowerResult.contains('kematangan')) {
      return 'Pisang sudah sangat matang. Tekstur lembek. Cocok untuk smoothie atau kue pisang.';
    }
    if (lowerResult.contains('busuk')) {
      return 'Pisang sudah tidak layak konsumsi. Terdapat bintik hitam dan tekstur terlalu lembek.';
    }
    return 'Hasil klasifikasi pisang Anda.';
  }

  // Get recommendation based on classification
  String _getRecommendation(String result) {
    final lowerResult = result.toLowerCase();
    if (lowerResult.contains('mentah')) {
      return '💡 Simpan dalam suhu ruang selama 2-3 hari agar matang.';
    }
    if (lowerResult.contains('matang') && !lowerResult.contains('terlalu')) {
      return '💡 Konsumsi segera untuk rasa terbaik atau simpan di kulkas.';
    }
    if (lowerResult.contains('terlalu') || lowerResult.contains('kematangan')) {
      return '💡 Gunakan untuk membuat smoothie, kue, atau pancake pisang.';
    }
    if (lowerResult.contains('busuk')) {
      return '💡 Sebaiknya tidak dikonsumsi untuk kesehatan.';
    }
    return '💡 Perhatikan kondisi pisang untuk penggunaan optimal.';
  }

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(hasil);
    final resultIcon = _getResultIcon(hasil);
    final description = _getDescription(hasil);
    final recommendation = _getRecommendation(hasil);

    return Scaffold(
      backgroundColor: Color(0xFFFFF9E6),
      appBar: AppBar(
        title: Text(
          "Hasil Identifikasi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.amber[800],
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur berbagi segera hadir!')),
              );
            },
            tooltip: 'Bagikan hasil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview Section
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  // Confidence badge (if available)
                  if (confidence != null)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: resultColor,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${(confidence! * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Result Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    resultColor.withOpacity(0.1),
                    resultColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: resultColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: resultColor.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Result Icon
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: resultColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      resultIcon,
                      size: 48,
                      color: resultColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Result Title
                  Text(
                    'Klasifikasi:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Result Value
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: resultColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      hasil.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Description
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Recommendation Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Rekomendasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    recommendation,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Scan Lagi'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber[800],
                        side: BorderSide(color: Colors.amber[700]!, width: 2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: Icon(Icons.home),
                      label: Text('Beranda'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}