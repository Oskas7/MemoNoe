import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_noe/api_data/api_liste_institution.dart';
import 'package:memo_noe/modeles/institution_model.dart';
import 'package:http/http.dart' as http;

class LiteInstitutionDialogue extends StatefulWidget {

  @override
  _LiteInstitutionDialogueState createState() => _LiteInstitutionDialogueState();
}

class _LiteInstitutionDialogueState extends State<LiteInstitutionDialogue> {

  late TextEditingController _searchQuery;

  late List<InstitutionModel> filteredRecored = [];
  late List<InstitutionModel> allRecord;

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

  //clear search box data.
  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
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

  filterList(InstitutionModel donnee, String searchQuery) {
    setState(() {
      if (donnee.designation.toString().toLowerCase().contains(searchQuery.toString().toLowerCase()) ||
          donnee.adresse.toString().toLowerCase().contains(searchQuery.toString().toLowerCase()) ||
          donnee.devise.toString().toLowerCase().contains(searchQuery.toString().toLowerCase())) {
        filteredRecored.add(donnee);
      }
    });
  }

  displayRecord() {
    setState(() {});
  }

  @override
  void screenUpdate() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(top: 20, bottom: 20),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Liste Institutions", style: TextStyle(fontSize: 14),),
          SizedBox(height: 10,),
          TextFormField(
            controller: _searchQuery,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(color: Colors.blue)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                hintText: "Recherche",
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.grey)),
            onChanged: updateSearchQuery,
          )
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.2,
        child: filteredRecored != null && filteredRecored.length > 0
            ? new ListView.builder(
            itemCount: filteredRecored == null ? 0 : filteredRecored.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, filteredRecored[index].id_institution+"<>"+filteredRecored[index].designation);
                },
                child: new Card(
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  filteredRecored[index].designation,
                                  // set some style to text
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black87, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
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
      actions: <Widget>[
        FlatButton(
            child: Text('   Annuler   ', style: TextStyle(color: Colors.white),),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.blue,
            onPressed: () => setState(() {
              Navigator.pop(context);
            }))
      ],
    );
  }
}
