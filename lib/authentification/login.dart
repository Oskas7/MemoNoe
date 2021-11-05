import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memo_noe/Variables/variables_globales.dart';
import 'package:memo_noe/frames/Accueil.dart';
import 'package:memo_noe/modeles/utilisateur_model.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:status_alert/status_alert.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String nom_utilisateur = "", mot_de_passe = "";
  bool isLoading = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Connexion...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  connexionAuServeur(nomutilisateur, codeutilisateur) async {
    showLoaderDialog(context);
    String _url = "http://" +
        VariablesGlobales.serveur +
        "/memo_noe/getData.php?operation=getLogin&nom_utilisateur=" +
        nomutilisateur +
        "&mot_de_passe=" +
        codeutilisateur;
    final response = await http.get(Uri.parse(_url), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
    });

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      debugPrint("ReponseOS:"+response.body);

      //Fermer la progression
      Navigator.pop(context);

      if(response.body.toString().contains("{")){
        final parsed = json
            .decode(response.body)["Donnee"]
            .cast<Map<String, dynamic>>();

        List<UtilisateurModel> recordUser = parsed.map<UtilisateurModel>((json) => new UtilisateurModel.fromJson(json)).toList();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return Accueil();
          }),
              (route) => false,
        );
      }else{
        setState(() {
          StatusAlert.show(
            context,
            duration: Duration(seconds: 4),
            title: 'Message',
            subtitle: "Nom d'utilisateur ou mot de passe incorrect",
            configuration: IconConfiguration(icon: Icons.error),
          );
        });
      }
    } else {
      Navigator.pop(context);
      StatusAlert.show(
        context,
        duration: Duration(seconds: 4),
        title: 'Message',
        subtitle: "Echec de connexion",
        configuration: IconConfiguration(icon: Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .subtitle;

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.blue,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 100),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Hero(
                                tag: 'logoAnimation',
                                child: Image.asset('assets/images/computer_lock_icon.png',
                                  height: 200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 10),
                                  hintText: "Nom d'utilisateur",
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey)),
                              onSaved: (val) {
                                nom_utilisateur = val!;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              onFieldSubmitted: _handleSubmission,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 10),
                                  hintText: "Mot de passe",
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey)),
                              onSaved: (val) {
                                mot_de_passe = val!;
                              },
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: RaisedButton(
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.white, width: 2)
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                seConnecter();
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          FlatButton(
                            onPressed: () async {

                            },
                            child: Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmission(String text) {
    seConnecter();
  }

  void seConnecter(){
    if (isLoading) {
      return;
    }
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text("Veuillez compléter les champs")));
      //return;
    }else{
      connexionAuServeur(_usernameController.text, _passwordController.text);
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

}
