import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Tomadoc',
      home: LoginPage(), // langsung ke login
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/main': (context) =>
            MainPage(), // MainPage tetap ada untuk navigasi setelah login
      },
    );
  }
}
