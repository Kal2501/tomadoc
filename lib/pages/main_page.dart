import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'camera_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), CameraPage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey[700],
        selectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Camera",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
