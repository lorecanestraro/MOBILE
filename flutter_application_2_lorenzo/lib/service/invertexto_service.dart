import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class InvertextoService {
  final String _token = "21566|VfxGt4K9Fva76UmZBNyDo9V20CuG01HI";

  Future<Map<String, dynamic>> convertePorExtenso(String? valor) async{
    try{
      final uri = Uri.parse("https://api.invertexto.com/v1/number-to-words?token=$_token&number=$valor&language=pt&currency=BRL");
      final response = await http.get(uri);
      if(response.statusCode == 200){
        return json.decode(response.body);
      }else{
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }

    }on SocketException{
      throw Exception("Erro de conexao com a internet");
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCEP(String? valor) async{
    try{
      final uri = Uri.parse("https://api.invertexto.com/v1/cep/$valor?token=$_token");
      final response = await http.get(uri);
      if(response.statusCode == 200){
        return json.decode(response.body);
      }else{
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }

    }on SocketException{
      throw Exception("Erro de conexao com a internet");
    }catch(e){
      rethrow;
    }
  }
}