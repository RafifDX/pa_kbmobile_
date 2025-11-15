import 'dart:typed_data';
import 'dart:io'; // Untuk File di mobile
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ✅ Ganti dart:html dengan ini
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Uint8List? imageBytes;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // ============================================
  // Send to Server
  // ============================================
  Future<Map<String, dynamic>> sendToServer(Uint8List bytes) async {
    try {
      debugPrint("=== DEBUG START ===");
      debugPrint("File size: ${bytes.length} bytes");

      // Ganti dengan IP komputer kamu untuk testing di mobile
      // Cari IP dengan cmd > ipconfig (Windows) atau ifconfig (Mac/Linux)
      final urls = [
        "http://192.168.100.108/api/predict-image/", // ✅ GANTI IP INI
        "http://10.0.2.2:8000/api/predict-image/", // Android Emulator
      ];

      for (var urlString in urls) {
        debugPrint("\n>>> Mencoba URL: $urlString");

        try {
          final uri = Uri.parse(urlString);
          final request = http.MultipartRequest("POST", uri);

          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: "upload.jpg",
            ),
          );

          debugPrint("Mengirim request...");

          final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception("Timeout - server tidak merespon dalam 30 detik");
            },
          );

          final resBody = await streamedResponse.stream.bytesToString();
          debugPrint("✅ Response diterima! Status: ${streamedResponse.statusCode}");
          debugPrint("Response body: $resBody");

          if (streamedResponse.statusCode == 200) {
            final json = jsonDecode(resBody);
            
            if (json["prediction"] != null) {
              if (json["prediction"] is Map) {
                return {
                  'success': true,
                  'prediction': json["prediction"]["prediction"] ?? "Tidak ada hasil",
                  'confidence': json["prediction"]["confidence"] ?? 0.0,
                };
              } else {
                return {
                  'success': true,
                  'prediction': json["prediction"],
                  'confidence': json["confidence"] ?? 0.0,
                };
              }
            }
            
            return {'success': false, 'error': 'Format response tidak valid'};
          } else {
            debugPrint("❌ Status error: ${streamedResponse.statusCode}");
            continue;
          }
        } catch (e) {
          debugPrint("❌ Error untuk $urlString: $e");
          continue;
        }
      }

      return {
        'success': false,
        'error': 'Tidak bisa terhubung ke server. Pastikan Django running dan gunakan IP yang benar.'
      };
    } catch (e) {
      debugPrint("❌ FATAL ERROR: $e");
      return {'success': false, 'error': e.toString()};
    }
  }

  // ======================
  // Pick Image from Gallery
  // ======================
  Future<void> pickImageFromGallery() async {
    if (isLoading) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Tidak ada gambar yang dipilih"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => isLoading = true);

      // Read file as bytes
      final bytes = await image.readAsBytes();
      
      setState(() {
        imageBytes = bytes;
      });

      // Send to server
      final result = await sendToServer(bytes);

      if (!mounted) return;
      setState(() => isLoading = false);

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanResultPage(
              imageBytes: bytes,
              hasil: result['prediction'],
              confidence: result['confidence'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ ${result['error']}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================
  // Take Photo with Camera
  // ======================
  Future<void> takePhoto() async {
    if (isLoading) return;

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Tidak ada foto yang diambil"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => isLoading = true);

      final bytes = await photo.readAsBytes();
      
      setState(() {
        imageBytes = bytes;
      });

      final result = await sendToServer(bytes);

      if (!mounted) return;
      setState(() => isLoading = false);

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanResultPage(
              imageBytes: bytes,
              hasil: result['prediction'],
              confidence: result['confidence'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ ${result['error']}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E6),
      appBar: AppBar(
        title: const Text(
          "Scan Pisang",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[800],
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Info
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber[800], size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Upload foto pisang untuk identifikasi tingkat kematangan',
                          style: TextStyle(
                            color: Colors.amber[900],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Preview Image
                if (imageBytes != null && !isLoading)
                  Container(
                    height: 250,
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(
                            imageBytes!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Gambar siap',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Upload Button
                ElevatedButton.icon(
                  onPressed: isLoading ? null : pickImageFromGallery,
                  icon: Icon(Icons.upload_file, size: 28),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      imageBytes == null ? 'Pilih dari Galeri' : 'Pilih Gambar Lain',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),

                const SizedBox(height: 16),

                // Camera Button
                OutlinedButton.icon(
                  onPressed: isLoading ? null : takePhoto,
                  icon: Icon(Icons.camera_alt, size: 24),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Ambil Foto',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber[800],
                    side: BorderSide(color: Colors.amber[700]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Tips Section
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Tips Foto yang Baik',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildTipItem('Pastikan pencahayaan cukup'),
                      _buildTipItem('Foto pisang secara utuh'),
                      _buildTipItem('Hindari background yang ramai'),
                      _buildTipItem('Pastikan fokus gambar tajam'),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.amber[300],
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Menganalisis gambar...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Mohon tunggu sebentar",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}