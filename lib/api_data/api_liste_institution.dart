import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:memo_noe/Variables/variables_globales.dart';

Future<String> fetchListeInstitutions(http.Client client) async {
  final response = await client.get(Uri.parse("http://"+VariablesGlobales.serveur+"/memo_noe/getData.php?operation=getListeInstitution"));
  return response.body;
}