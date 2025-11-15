import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  // CEK PERTAMA KALI APLIKASI DIBUKA
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? first = prefs.getBool("first_launch");

    if (first == null || first == true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showTutorialPopup();
      });

      prefs.setBool("first_launch", false);
    }
  }

  // POPUP TUTORIAL
  void _showTutorialPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
              SizedBox(width: 8),
              Text("Tutorial Aplikasi"),
            ],
          ),
          content: Text(
            "Ingin melihat tutorial penggunaan aplikasi untuk mengidentifikasi tingkat kematangan pisang?",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Nanti Saja", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/tutorial");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Lihat Tutorial"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E6),

      // =======================
      //     APP BAR ATAS
      // =======================
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        elevation: 2,
        title: Text(
          'Klasifikasi Buah Pisang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/tutorial'),
            tooltip: 'Tutorial',
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/about'),
            tooltip: 'About Us',
          ),
        ],
      ),

      // =======================
      //       BODY UTAMA
      // =======================
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[800]!, Colors.amber[600]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt_rounded, size: 56, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Identifikasi Tingkat Kematangan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Upload foto pisang untuk mengetahui tingkat kematangannya',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Classification Guide
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panduan Klasifikasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kenali tingkat kematangan pisang berdasarkan karakteristiknya',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Grid of classifications
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Adjust columns based on screen width
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                      double childAspectRatio = constraints.maxWidth > 600 ? 0.85 : 0.75;
                      
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: childAspectRatio,
                        children: [
                          BananaCategoryBox(
                            title: 'Mentah',
                            description: 'Kulit hijau, keras',
                            imagePath: 'assets/images/mentah.jpg',
                            color: Colors.green,
                            icon: Icons.circle,
                          ),
                          BananaCategoryBox(
                            title: 'Matang',
                            description: 'Kuning, siap konsumsi',
                            imagePath: 'assets/images/matang.jpg',
                            color: Colors.amber,
                            icon: Icons.circle,
                          ),
                          BananaCategoryBox(
                            title: 'Terlalu Matang',
                            description: 'Sangat matang, lembek',
                            imagePath: 'assets/images/kematangan.jpg',
                            color: Colors.orange,
                            icon: Icons.circle,
                          ),
                          BananaCategoryBox(
                            title: 'Busuk',
                            description: 'Tidak layak konsumsi',
                            imagePath: 'assets/images/busuk.jpg',
                            color: Colors.brown,
                            icon: Icons.circle,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 80), // Space for floating button
                ],
              ),
            ),
          ],
        ),
      ),

      // =====================================
      //  TOMBOL SCAN DI TENGAH BAWAH
      // =====================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[800],
        onPressed: () {
          Navigator.pushNamed(context, '/scan');
        },
        icon: Icon(Icons.camera_alt, color: Colors.white),
        label: Text(
          'Scan Pisang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// =======================
//  WIDGET KOTAK GRID
// =======================
class BananaCategoryBox extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color color;
  final IconData icon;

  const BananaCategoryBox({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar dengan aspect ratio konsisten
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 32,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                  // Gradient overlay untuk readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Info section
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 10, color: color),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}