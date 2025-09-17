import 'package:flutter/material.dart';
import 'package:flutter_application_2_lorenzo/service/invertexto_service.dart';

class ConversaoMoedaPage extends StatefulWidget {
  const ConversaoMoedaPage({super.key});

  @override
  State<ConversaoMoedaPage> createState() => _ConversaoMoedaPageState();
}

class _ConversaoMoedaPageState extends State<ConversaoMoedaPage> {
  String? valor;
  String? resultado;
  final apiService = InvertextoService();
  final TextEditingController valorController = TextEditingController();
  String moedaOrigem = 'USD';
  String moedaDestino = 'BRL';

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: valorController,
              decoration: InputDecoration(
                labelText: "Digite o valor",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (value) {
                setState(() {
                  valor = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButton<String>(
                    value: moedaOrigem,
                    onChanged: (String? newValue) {
                      setState(() {
                        moedaOrigem = newValue!;
                      });
                    },
                    items: <String>['USD', 'EUR', 'GBP', 'BRL']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: moedaDestino,
                    onChanged: (String? newValue) {
                      setState(() {
                        moedaDestino = newValue!;
                      });
                    },
                    items: <String>['USD', 'EUR', 'GBP', 'BRL']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (valor != null && valor!.isNotEmpty) {
                  try {
                    final response = await apiService.converteMoeda(
                      moedaOrigem,
                      moedaDestino,
                      valor!,
                    );
                    setState(() {
                      resultado = response["valorConvertido"].toString();
                    });
                  } catch (e) {
                    setState(() {
                      resultado = "Erro ao converter: $e";
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text("Converter", style: TextStyle(color: Colors.black)),
            ),

            SizedBox(height: 20),
            if (resultado != null)
              Text(
                resultado!,
                style: TextStyle(
                  color: resultado!.startsWith("Erro")
                      ? Colors.red
                      : Colors.white,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
