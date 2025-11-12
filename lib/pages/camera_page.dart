import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  // Dummy hasil analisis
  String diagnosis =
      "Mengandung penyakit lorem ipsum dolor sit amet, consectetur adipiscing elit.";
  double accuracy = 75.0;
  String recommendation =
      "Lakukan penyiraman teratur dan hindari paparan air berlebih.";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Dari kamera
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = join(
        directory.path,
        "${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final image = await _controller!.takePicture();
      await image.saveTo(imagePath);

      final cropped = await _cropSquare(File(imagePath));
      setState(() {
        _capturedImage = cropped;
      });

      await _predictImage();

      if (_controller != null) {
        await _controller!.dispose();
        _controller = null;
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint("Error mengambil foto: $e");
    }
  }

  // Pake image picker
  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final cropped = await _cropSquare(File(pickedFile.path));
        setState(() {
          _capturedImage = cropped;
        });

        await _predictImage();

        if (_controller != null) {
          await _controller!.dispose();
          _controller = null;
          if (mounted) setState(() {});
        }
      }
    } catch (e) {
      debugPrint("Error memilih gambar: $e");
    }
  }

  // Fungsi crop square (rasio 1:1)
  Future<File> _cropSquare(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return imageFile;

    final size = originalImage.width < originalImage.height
        ? originalImage.width
        : originalImage.height;
    final offsetX = (originalImage.width - size) ~/ 2;
    final offsetY = (originalImage.height - size) ~/ 2;

    final croppedImage = img.copyCrop(
      originalImage,
      x: offsetX,
      y: offsetY,
      width: size,
      height: size,
    );

    final directory = await getTemporaryDirectory();
    final croppedPath = join(
      directory.path,
      'cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final croppedFile = File(croppedPath)
      ..writeAsBytesSync(img.encodeJpg(croppedImage));

    return croppedFile;
  }

  // Ambil ulang
  Future<void> _retake() async {
    setState(() {
      _capturedImage = null;
    });
    await _initCamera();
  }


  // Upload dan prediksi image API
  Future<void> _predictImage() async{
    if (_capturedImage == null) return;
// 'https://pakbmobile.loca.lt/api/predict'
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://shaina-untemperate-gary.ngrok-free.dev/api/predict')
      );

      request.files.add(await http.MultipartFile.fromPath('image', _capturedImage!.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200){
        var data = jsonDecode(responseBody);

        String label = data['predicted_label'] ?? 'Tidak diketahui';

        String confidence = data['confidence'] ?? '0%';

        if (!mounted) return;
        setState(() {
          diagnosis = label;
          accuracy = double.tryParse(confidence.replaceAll('%', '')) ?? 0.0;
        });
      }else{

        debugPrint("Error,  Status: ${response.statusCode}");
      }

    }
    catch (e){
      debugPrint("Error: ${e.toString()}", wrapWidth: 1024);
      if (!mounted) return;
      setState(() {
        diagnosis = e.toString();
      });
    }

  }

  Widget _buildResultCard(
    String title,
    String content, {
    bool isAccuracy = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isAccuracy ? "${content}%" : content,
            style: GoogleFonts.quicksand(fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Camera",
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: _capturedImage == null
            ? (_controller == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CameraPreview(_controller!),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _takePicture,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                "Ambil Foto",
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _pickFromGallery,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                "Pilih dari Galeri",
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ))
            : Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _capturedImage!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _retake,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Ambil Ulang",
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildResultCard("Daun Tomat kamu terkena ", diagnosis),
                      _buildResultCard(
                        "Tingkat Akurasi",
                        accuracy.toString(),
                        isAccuracy: true,
                      ),
                      _buildResultCard("Saran dari kami", recommendation),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
