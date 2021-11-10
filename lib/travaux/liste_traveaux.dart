import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_noe/Variables/variables_globales.dart';
import 'package:memo_noe/api_data/api_liste_traveaux.dart';
import 'package:http/http.dart' as http;
import 'package:memo_noe/modeles/travail_model.dart';
import 'package:memo_noe/travaux/nouveau_travail.dart';

import 'package:url_launcher/url_launcher.dart' as ul;

class ListeTraveaux extends StatefulWidget {

  @override
  _ListeTraveauxState createState() =>
      _ListeTraveauxState();
}

class _ListeTraveauxState extends State<ListeTraveaux>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  //it will hold search box value
  late TextEditingController _searchQuery;
  bool _isSearching = false; //maintain search box on/off state

  late List<TravailModel> filteredRecored = [];

  bool dialVisible = true;

  String etat_facture = "0";

  //getting data from the server
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();

    _fetchListeTraveaux();
  }

  _fetchListeTraveaux() {
    fetchListeTraveaux(new http.Client())
        .then((String) {
      parseData(String);
    });
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  late List<TravailModel> allRecord = [];

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Chargement encours...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //parsing server response.
  parseData(String responseBody) {
    final parsed =
        json.decode(responseBody)["Donnee"].cast<Map<String, dynamic>>();
    setState(() {
      allRecord = parsed
          .map<TravailModel>((json) => new TravailModel.fromJson(json))
          .toList();
    });
    filteredRecored = <TravailModel>[];
    filteredRecored.addAll(allRecord);
  }

  //It'll open search box
  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  //It'll close search box.
  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      filteredRecored.addAll(allRecord);
    });
  }

  //clear search box data.
  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  //Create a app bar title widget
  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => (){},
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text("TRAVAUX",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Creating search box widget
  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Recherche',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  //It'll update list items atfer searching complete.
  void updateSearchQuery(String newQuery) {
    filteredRecored.clear();
    if (newQuery.length > 0) {
      Set<TravailModel> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }
    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
    }
    setState(() {});
  }

  //Filtering the list item with found match string.
  filterList(TravailModel donnee, String searchQuery) {
    setState(() {
      if (donnee.id_etudiant.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          donnee.id_institution.toLowerCase().contains(searchQuery.toLowerCase()) ||
          donnee.sujet.toLowerCase().contains(searchQuery.toLowerCase())||
          donnee.categorie.toLowerCase().contains(searchQuery.toLowerCase())||
          donnee.directeur.toLowerCase().contains(searchQuery.toLowerCase())||
          donnee.encadreur.toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredRecored.add(donnee);
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white70,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white),
              leading: _isSearching
                  ? new BackButton(
                      color: Colors.white,
                    )
                  : null,
              title: _isSearching ? _buildSearchField() : _buildTitle(context),
              actions: _buildActions(),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    heroTag: "tag1",
                    label: Text("Ajouter", style: TextStyle(color: Colors.black),),
                    icon: new Icon(Icons.add, color: Colors.black,),
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NouveauTravail(operation: "ajouter",),
                          ));
                      //Resultat
                      if(result == "succes"){
                        setState(() {
                          _fetchListeTraveaux();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            body: filteredRecored != null && filteredRecored.length > 0
                ? new Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: new ListView.builder(
                  itemCount: filteredRecored == null ? 0 : filteredRecored.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(filteredRecored[index].id_etudiant),
                                content: setupAlertDialoadContainer(
                                    filteredRecored[index].id_institution.toString(),
                                    filteredRecored[index].id_etudiant.toString()),
                              );
                            });
                      },
                      child: new Card(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 100,
                                      child: Text((index + 1).toString()+".  "+filteredRecored[index].sujet.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(filteredRecored[index].id_etudiant.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue))),
                                  Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(filteredRecored[index].id_institution.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.blue)),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Directeur : "+filteredRecored[index].directeur.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 10, color: Colors.orange))),
                                  Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Encadreur : "+filteredRecored[index].encadreur.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 10,
                                                color: Colors.orange)),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
                : allRecord == null
                    ? new Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      )
                    : new Center(
                        child: new Text("Aucune donnée trouvée"),
                      ),
          ),
        ),
      ],
    );
  }

  Widget setupAlertDialoadContainer(String id_institution, String id_etudiant) {
    return Container(
      height: 220.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: InkWell(
                onTap: () async {
                  debugPrint(index.toString());
                  Navigator.pop(context);
                  if (index == 0) {
                    ul.launch(
                      "http://"+VariablesGlobales.serveur+"/memo_noe/"+id_etudiant.toString()+".PNG",
                    );
                  }

                  if (index == 1) {

                  }

                  if (index == 2) {

                  }

                  if (index == 3) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  index == 0
                      ? "Télécharger PDF"
                      : index == 1
                      ? "Modifier"
                      : index == 2
                      ? "Supprimer"
                      : index == 3
                      ? "Annuler"
                      : "",
                ),
              ));
        },
      ),
    );
  }

}
