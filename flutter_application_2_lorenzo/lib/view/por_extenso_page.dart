import 'package:flutter/material.dart';
import 'package:flutter_application_2_lorenzo/service/invertexto_service.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  String? resultado;
  String moedaSelecionada = "BRL"; // valor padrão
  final apiService = InvertextoService();

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
            // CAMPO DE TEXTO
            TextField(
              decoration: InputDecoration(
                labelText: "Digite um número",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),

            SizedBox(height: 15),

            // DROPDOWN DE MOEDA
            DropdownButton<String>(
              dropdownColor: Colors.black,
              value: moedaSelecionada,
              items: const [
                DropdownMenuItem(
                  value: "BRL",
                  child: Text(
                    "Real (BRL)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: "USD",
                  child: Text(
                    "Dólar (USD)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: "EUR",
                  child: Text(
                    "Euro (EUR)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: "JPY",
                  child: Text(
                    "Iene (JPY)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  moedaSelecionada = value!;
                });
              },
            ),

            Expanded(
              child: FutureBuilder(
                future: campo == null
                    ? null
                    : apiService.convertePorExtenso(
                        campo,
                        currency: moedaSelecionada,
                      ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Erro: ${snapshot.error}",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Text(
                          "Digite um número acima",
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
