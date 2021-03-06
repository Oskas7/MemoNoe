import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_noe/api_data/api_liste_institution.dart';
import 'package:memo_noe/institution/nouvelle_institution.dart';
import 'package:memo_noe/modeles/institution_model.dart';
import 'package:http/http.dart' as http;

class ListeInstitutions extends StatefulWidget {

  @override
  _ListeInstitutionsState createState() =>
      _ListeInstitutionsState();
}

class _ListeInstitutionsState extends State<ListeInstitutions>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  //it will hold search box value
  late TextEditingController _searchQuery;
  bool _isSearching = false; //maintain search box on/off state

  late List<InstitutionModel> filteredRecored = [];

  bool dialVisible = true;

  String etat_facture = "0";

  //getting data from the server
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();

    _fetchListeInstitutions();
  }

  _fetchListeInstitutions() {
    fetchListeInstitutions(new http.Client())
        .then((String) {
      parseData(String);
    });
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  late List<InstitutionModel> allRecord = [];

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
          .map<InstitutionModel>((json) => new InstitutionModel.fromJson(json))
          .toList();
    });
    filteredRecored = <InstitutionModel>[];
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
            new Text("INSTITUTIONS",
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
      Set<InstitutionModel> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }
    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
    }
    setState(() {});
  }

  //Filtering the list item with found match string.
  filterList(InstitutionModel donnee, String searchQuery) {
    setState(() {
      if (donnee.devise.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          donnee.designation.toLowerCase().contains(searchQuery.toLowerCase()) ||
          donnee.adresse.toLowerCase().contains(searchQuery.toLowerCase())) {
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
                            builder: (context) => NouvelleInstitution(operation: "ajouter",),
                          ));
                      //Resultat
                      if(result == "succes"){
                        setState(() {
                          _fetchListeInstitutions();
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
                                title: Text(filteredRecored[index].designation),
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
                                      child: Text((index + 1).toString()+".  "+filteredRecored[index].designation.toString(),
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
                                      child: Text(filteredRecored[index].devise.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue))),
                                  Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(filteredRecored[index].adresse.toString(),
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
              child: new Text("Aucune donn??e trouv??e"),
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
