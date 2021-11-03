import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memo_noe/etudiant/liste_etudiants.dart';
import 'package:memo_noe/institution/liste_institutions.dart';
import 'package:memo_noe/travaux/liste_traveaux.dart';

class Accueil extends StatefulWidget {

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          //Padding widget
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Hero(
                tag: '_animation',
                child: Image.asset(
                  'assets/images/books_icon.png',
                  height: 200,
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Conception et réalisation d’une application Web et Mobile "
                      "muni d’un moteur de recherche pour les mémoires et travaux de fin cycle."
                      " Cas de Beni et Butembo.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'WorkSans'),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Expanded(
              child: Center(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: GridView.count(
                      crossAxisCount: (Platform.isAndroid || Platform.isIOS) ? 3 : 7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      children: [
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ListeInstitutions()));
                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.home, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text("Institution",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ListeEtudiants()));
                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.people, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text('Etudiant',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ListeTraveaux()));
                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.book, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text('Travaux',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {

                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.settings, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text('Paramètres',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {

                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.help, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text('Aide',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                        Card(
                          color: Colors.teal,
                          child: Padding(padding: const EdgeInsets.all(2.0),
                            child: InkWell(onTap: () {

                            },
                              child: Container(
                                width: 120.0,
                                child: Center(
                                  child: ListTile(
                                    title: Icon(Icons.power_settings_new, color: Colors.white,),
                                    subtitle: Container(
                                      child: Text('Quitter',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (Platform.isAndroid || Platform.isIOS) ? 10 : 14,
                                            color: Colors.white, ),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        child: Row(
          children: [
            Expanded(
                child: Container(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Date : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.white)),
                  ),
                )),
            Expanded(
              child: Container(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Réalisation KAKULE TSONGO Emanuel",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }
}
