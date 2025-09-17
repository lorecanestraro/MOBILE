import 'package:flutter/material.dart';
import 'package:flutter_application_2_lorenzo/view/busca_cep_page.dart';
import 'package:flutter_application_2_lorenzo/view/por_extenso_page.dart';
import 'package:flutter_application_2_lorenzo/view/conversao_moeda_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Por Extenso",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PorExtensoPage()),
                );
              },
            ),
            SizedBox(height: 30),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.home, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Busca CEP",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuscaCepPage()),
                );
              },
            ),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(Icons.monetization_on, color: Colors.white, size: 50.0),
                  SizedBox(width: 30),
                  Text(
                    "Conversão de Moeda",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConversaoMoedaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
