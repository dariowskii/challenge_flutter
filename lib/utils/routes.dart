import 'package:challenge_flutter/screens/home_screen.dart';
import 'package:challenge_flutter/screens/login_screen.dart';
import 'package:challenge_flutter/screens/registration_screen.dart';
import 'package:challenge_flutter/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String initialRoute =
    _auth.currentUser == null ? WelcomeScreen.id : HomeScreen.id;

Map<String, Widget Function(BuildContext)> applicationRoutes = {
  WelcomeScreen.id: (context) => WelcomeScreen(),
  RegistrationScreen.id: (context) => RegistrationScreen(),
  LoginScreen.id: (context) => LoginScreen(),
  HomeScreen.id: (context) => HomeScreen(),
};
