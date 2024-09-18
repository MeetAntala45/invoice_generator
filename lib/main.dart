import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'profile.dart';
import 'signup.dart';
import 'welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'theme.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDGymh5G8ZJAfaH2M8gjfBZIYlpUyUvRm0",
  authDomain: "invoice-6d5b4.firebaseapp.com",
  projectId: "invoice-6d5b4",
  storageBucket: "invoice-6d5b4.appspot.com",
  messagingSenderId: "619491442739",
  appId: "1:619491442739:web:f72293ffaf411e49aa6346",
  measurementId: "G-GP47T93D02"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialize Firebase for web
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    // Initialize Firebase for Android
    await Firebase.initializeApp();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: appTheme,
    title: 'Invoice Generator',
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/welcome': (context) => WelcomePage(),
      '/login': (context) => LoginScreen(),
      '/signup': (context) => SignupScreen(),
      '/index': (context) => HomePage(),
      '/profile': (context) => ProfilePage(),
    },

  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}