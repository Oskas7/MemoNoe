import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memo_noe/api_data/api_liste_etudiant.dart';
import 'package:memo_noe/etudiant/nouveau_etudiant.dart';
import 'package:memo_noe/institution/nouvelle_institution.dart';
import 'package:memo_noe/modeles/etudiant_model.dart';
import 'package:http/http.dart' as http;

class ListeEtudiants extends StatefulWidget {

  @override
  _ListeEtudiantsState createState() =>
      _ListeEtudiantsState();
}

class _ListeEtudiantsState extends State<ListeEtudiants>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  //it will hold search box value
  late TextEditingController _searchQuery;
  bool _isSearching = false; //maintain search box on/off state

  late List<EtudiantModel> filteredRecored = [];

  bool dialVisible = true;

  String etat_facture = "0";

  //getting data from the server
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();

    _fetchListeEtudiants();
  }

  _fetchListeEtudiants() {
    fetchListeEtudiants(new http.Client())
        .then((String) {
      parseData(String);
    });
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  late List<EtudiantModel> allRecord;

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
          .map<EtudiantModel>((json) => new EtudiantModel.fromJson(json))
          .toList();
    });
    filteredRecored = <EtudiantModel>[];
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
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => (){},
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text("ETUDIANTS",
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
      Set<EtudiantModel> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }
    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
    }
    setState(() {});
  }

  //Filtering the list item with found match string.
  filterList(EtudiantModel donnee, String searchQuery) {
    setState(() {
      if (donnee.nom.toString().toLowerCase().contains(searchQuery.toString().toLowerCase()) ||
          donnee.postnom.toLowerCase().contains(searchQuery.toString().toLowerCase()) ||
          donnee.prenom.toLowerCase().contains(searchQuery.toString().toLowerCase())||
          donnee.lieu_naissance.toLowerCase().contains(searchQuery.toString().toLowerCase())||
          donnee.faculte.toLowerCase().contains(searchQuery.toString().toLowerCase())||
          donnee.departement.toLowerCase().contains(searchQuery.toString().toLowerCase())||
          donnee.id_institution.toLowerCase().contains(searchQuery.toString().toLowerCase())) {
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
        (Platform.isAndroid || Platform.isIOS) ? Container() : Container(),
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
                            builder: (context) => NouveauEtudiant(operation: "ajouter",),
                          ));
                      //Resultat
                      if(result == "succes"){
                        setState(() {
                          _fetchListeEtudiants();
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
                                title: Text(filteredRecored[index].nom.toString()+" "+filteredRecored[index].postnom.toString()+" "+filteredRecored[index].prenom.toString()),
                                content: setupAlertDialoadContainer(
                                    filteredRecored[index].id_institution.toString()),
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
                                      child: Text((index + 1).toString()+".  "+filteredRecored[index].nom.toString()+" "+filteredRecored[index].postnom.toString()+" "+filteredRecored[index].prenom.toString(),
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
                                      child: Text(filteredRecored[index].departement.toString(),
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

  Widget setupAlertDialoadContainer(String id_institution) {
    return Container(
      height: 200.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: InkWell(
                onTap: () async {
                  debugPrint(index.toString());
                  Navigator.pop(context);
                  if (index == 0) {

                  }

                  if (index == 1) {

                  }

                  if (index == 2) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  index == 0
                      ? "Modifier"
                      : index == 1
                      ? "Supprimer"
                      : index == 2
                      ? "Annuler"
                      : "",
                ),
              ));
        },
      ),
    );
  }

}
