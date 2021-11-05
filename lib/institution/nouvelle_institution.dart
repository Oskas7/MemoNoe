import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:memo_noe/Variables/variables_globales.dart';
import 'package:status_alert/status_alert.dart';
import 'package:http/http.dart' as http;

class NouvelleInstitution extends StatefulWidget {
  final String operation;

  NouvelleInstitution({required this.operation});

  @override
  _NouvelleInstitutionState createState() =>
      _NouvelleInstitutionState();
}

class _NouvelleInstitutionState extends State<NouvelleInstitution> {

  TextEditingController _designation = TextEditingController();
  TextEditingController _adresse = TextEditingController();
  TextEditingController _devise = TextEditingController();

  GlobalKey<ScaffoldState>_scaffoldKey = GlobalKey();

  String nom_utilisateur = "";

  String message_erreur = "Echec d'enregistrement", status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black54,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              centerTitle: true,
              title: Text("NOUVELLE INSTITUTION",
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
                      controller: _designation,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {

                      },
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Désignation',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _adresse,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Adresse',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _devise,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          labelText: 'Devise',
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
                          if (_designation.text.isEmpty || _adresse.text.isEmpty || _devise.text.isEmpty) {
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
                                title: 'NOUVELLE INSTITUTION',
                                desc: "Voulez-vous vraiment enregistrer ?",
                                showCloseIcon: false,
                                btnCancelText: "Non",
                                btnOkText: "OUI",
                                btnOkOnPress: () {
                                  enregistrerCompte();
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

  enregistrerCompte() {
    showLoaderDialog(context);

    String url = "http://" + VariablesGlobales.serveur + "/memo_noe/mes_requettes.php?operation="
        "save_institution&designation=" + _designation.text.toString() + "&adresse="
        + _adresse.text.toString() + "&devise=" + _devise.text.toString();

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
