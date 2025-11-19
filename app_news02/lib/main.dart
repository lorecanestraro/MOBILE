import 'package:app_news02/view/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
