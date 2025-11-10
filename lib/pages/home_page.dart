import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "User";

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        setState(() {
          username = doc.data()?['username'] ?? "User";
        });
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> datasetSamples = [
      {
        "title": "Healthy",
        "image": "lib/assets/images/healthy.JPG",
        "desc":
            "Daun tomat dalam kondisi sehat tanpa gejala penyakit atau kerusakan fisik.",
      },
      {
        "title": "Late Blight",
        "image": "lib/assets/images/lateblight.JPG",
        "desc":
            "Infeksi jamur yang menyebabkan bercak coklat kehitaman dan busuk pada daun.",
      },
      {
        "title": "Septoria Leaf Spot",
        "image": "lib/assets/images/sephorialeafspot.JPG",
        "desc":
            "Bercak kecil berwarna abu-abu dengan tepi gelap yang disebabkan oleh jamur Septoria lycopersici.",
      },
      {
        "title": "Spider Mites",
        "image": "lib/assets/images/spidermites.JPG",
        "desc":
            "Serangan tungau menyebabkan daun menguning, menggulung, dan terdapat jaring halus.",
      },
      {
        "title": "Yellow Leaf Curl Virus",
        "image": "lib/assets/images/yellowleafcurlvirus.JPG",
        "desc":
            "Virus yang membuat daun menggulung, menebal, dan menguning sehingga pertumbuhan terhambat.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, $username!",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                "Selamat datang di TomaDoc",
                style: GoogleFonts.quicksand(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Tentang TomaDoc",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'lib/assets/images/logo.png',
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "TomaDoc adalah aplikasi cerdas berbasis kecerdasan buatan (AI) yang dirancang untuk membantu petani mendeteksi penyakit pada daun tomat dengan cepat dan akurat menggunakan teknologi Computer Vision.",
                        style: GoogleFonts.quicksand(fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sample Dataset",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Grid dengan container lebih tinggi
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62, // dibuat lebih tinggi
                  ),
                  itemCount: datasetSamples.length,
                  itemBuilder: (context, index) {
                    final item = datasetSamples[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item["image"]!,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["title"]!,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              item["desc"]!,
                              style: GoogleFonts.quicksand(fontSize: 11),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
