import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_switch/material_switch.dart';
import 'package:memo_noe/Variables/variables_globales.dart';
import 'package:memo_noe/popups/dial_client_par_groupe.dart';
import 'package:status_alert/status_alert.dart';
import 'package:http/http.dart' as http;

class NouveauEtudiant extends StatefulWidget {
  final String operation;

  NouveauEtudiant({required this.operation});

  @override
  _NouveauEtudiantState createState() =>
      _NouveauEtudiantState();
}

class _NouveauEtudiantState extends State<NouveauEtudiant> {

  TextEditingController _nom = TextEditingController();
  TextEditingController _postnom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _date_naissance = TextEditingController();
  TextEditingController _lieu_naissance = TextEditingController();
  TextEditingController _faculte = TextEditingController();
  TextEditingController _departement = TextEditingController();
  TextEditingController _institution = TextEditingController();

  DateTime selectedDate = DateTime.now();

  GlobalKey<ScaffoldState>_scaffoldKey = GlobalKey();

  List<String> switchOptions = ["HOMME", "FEMME"];
  String selectedSwitchOption = "HOMME";

  String nom_utilisateur = "";

  String message_erreur = "Echec d'enregistrement", status = "";

  String id_institution = "0", _sexe = "M";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    _date_naissance.text = formattedDate;
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (Platform.isAndroid || Platform.isIOS) ? Container() : Container(),
        Expanded(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black54,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              centerTitle: true,
              title: Text("NOUVEAU ETUDIANT",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              elevation: 0.0,
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _nom,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {

                      },
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Nom',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _postnom,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Post-Nom',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _prenom,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Prénom',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  MaterialSwitch(
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.all(5.0),
                    selectedOption: selectedSwitchOption,
                    options: switchOptions,
                    selectedBackgroundColor: Colors.blue,
                    selectedTextColor: Colors.white,
                    onSelect: (String selectedOption) {
                      setState(() {
                        selectedSwitchOption = selectedOption;
                        if(selectedSwitchOption == "HOMME"){
                          _sexe = "M";
                        }
                        if(selectedSwitchOption == "FEMME"){
                          _sexe = "F";
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _lieu_naissance,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Lieu de naissance',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextField(
                      controller: _date_naissance,
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        labelText: 'Date de naissance',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0)),
                        suffixIcon: InkWell(child: Icon(Icons.date_range, color: Colors.white,), onTap: () => _selectDate(context),),
                        prefixIcon: InkWell(child: Icon(Icons.date_range, color: Colors.white,), onTap: () => _selectDate(context),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _institution,
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        labelText: 'Institution',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5.0)),
                        suffixIcon: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onTap: () async {
                            String _veh = await showDialog(
                              context: this.context,
                              builder: (context) =>
                              new ClientParGroupeDialogue(),
                            );

                            var arr = _veh.split('<>');

                            id_institution = arr[0];

                            _institution.text = arr[1].toString();
                          },
                        ),
                        prefixIcon: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onTap: () async {
                            String _veh = await showDialog(
                              context: this.context,
                              builder: (context) =>
                              new ClientParGroupeDialogue(),
                            );

                            var arr = _veh.split('<>');

                            id_institution = arr[0];

                            _institution.text = arr[1].toString();
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _faculte,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Faculté',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _departement,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Département',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        widget.operation == "ajouter" ? "ENREGISTRER" : "MODIFIER",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.white, width: 2)
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        if(widget.operation == "ajouter"){
                          //Enregistrer
                          if (_nom.text.isEmpty || _postnom.text.isEmpty || _prenom.text.isEmpty || _institution.text.isEmpty) {
                            _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text("Veuillez renseigner les informations")));
                            return;
                          } else {
                            setState(() {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                borderSide: BorderSide(color: Colors.green, width: 2),
                                width: 380,
                                buttonsBorderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                headerAnimationLoop: false,
                                animType: AnimType.SCALE,
                                title: 'NOUVEAU ETUDIANT',
                                desc: "Voulez-vous vraiment enregistrer ?",
                                showCloseIcon: false,
                                btnCancelText: "Non",
                                btnOkText: "OUI",
                                btnOkOnPress: () {
                                  enregistrerInstitution();
                                },
                                btnCancelOnPress: () {},
                              )
                                ..show();
                            });
                          }
                        }
                        if(widget.operation == "modifier"){
                          setState(() {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              borderSide: BorderSide(color: Colors.green, width: 2),
                              width: 380,
                              buttonsBorderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              title: 'MODIFICATION',
                              desc: "Voulez-vous vraiment modifier ?",
                              showCloseIcon: false,
                              btnCancelText: "Non",
                              btnOkText: "OUI",
                              btnOkOnPress: () {
                                //modifierCompte();
                              },
                              btnCancelOnPress: () {},
                            )
                              ..show();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),
              child: Text("Chargement encours...")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // Refer step 1
        firstDate: DateTime(1980),
        lastDate: DateTime(2225),
        helpText: "DATE DE NAISSANCE",
        cancelText: "ANNULER",
        confirmText: "CONFIRMER");
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

        _date_naissance.text = formattedDate;
      });
  }

  enregistrerInstitution() {
    showLoaderDialog(context);

    String url = "http://" + VariablesGlobales.serveur + "/memo_noe/mes_requettes.php?operation="
        "save_etudiant&nom="+_nom.text.toString()+"&postnom="+_postnom.text.toString()+"&prenom="+
        _prenom.text.toString()+"&sexe="+_sexe+"&date_naissance="+_date_naissance.text.toString()
        +"&lieu_naissance="+_lieu_naissance.text.toString()+"&faculte="+_faculte.text.toString()
        +"&departement="+_departement.text.toString()+"&id_institution="+id_institution+"&photo=-";

    url.replaceAll("", "%20");

    debugPrint(url);

    http.get(Uri.parse(url)).then((result) {
      Navigator.pop(context);
      setStatus(result.statusCode == 200 ? result.body : message_erreur);

      if (status != message_erreur) {
        StatusAlert.show(
          context,
          duration: Duration(seconds: 4),
          title: 'Message',
          subtitle: 'Enregistrement effectué avec succès',
          configuration: IconConfiguration(icon: Icons.done),
        );

        Navigator.pop(context, "succes");
      }
    }).catchError((error) {
      Navigator.pop(context);
      setStatus(error);
      StatusAlert.show(
        context,
        duration: Duration(seconds: 4),
        title: 'Message',
        subtitle: status,
        configuration: IconConfiguration(icon: Icons.error),
      );
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

}
