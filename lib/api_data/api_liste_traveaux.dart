import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:memo_noe/Variables/variables_globales.dart';

Future<String> fetchListeTraveaux(http.Client client) async {
  final response = await client.get(Uri.parse("http://"+VariablesGlobales.serveur+"/memo_noe/getData.php?operation=getListeDesTravaux"));
  return response.body;
}