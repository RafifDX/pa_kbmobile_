import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PredictionProvider with ChangeNotifier {
  File? imageFile;
  String? predictionMessage;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk mengambil gambar dari galeri atau kamera
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Fungsi untuk mengirim gambar ke API dan mendapatkan prediksi
  Future<void> predictImage() async {
    if (imageFile == null) return;
    
    
    final url = Uri.parse('http://192.168.100.108/api/predict-image'); 
    // final url = Uri.parse('https://pakbmobile.loca.lt/api/predict-image'); 
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile!.path));  // Pastikan field image sesuai

    // (Optional) Tambahkan header jika API memerlukannya
    request.headers.addAll({
      'Content-Type': 'multipart/form-data', 
      // 'Authorization': 'Bearer YOUR_TOKEN', // Tambahkan jika perlu
    });

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseData');
      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        
        if (data['prediction'] != null && data['prediction'].isNotEmpty) {
          // Mengambil hasil prediksi pertama
          int prediction = data['prediction'][0];
          predictionMessage = 'Predicted digit: $prediction';
        } else {
          predictionMessage = 'Prediction failed';
        }
      } else {
        // Jika error, tampilkan pesan error
        predictionMessage = 'Error ${response.statusCode}: $responseData';
      }

      notifyListeners();
    } catch (e) {
      predictionMessage = 'Error: $e';
      notifyListeners();
    }
  }

  // Fungsi untuk menghapus gambar dan prediksi
  void clear() {
    imageFile = null;
    predictionMessage = null;
    notifyListeners();
  }
}