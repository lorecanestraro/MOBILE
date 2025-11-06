import 'package:auth/firebase_options.dart';
import 'package:auth/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false));
}
