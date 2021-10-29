class EtudiantModel {
  var id_etudiant;
  var nom;
  var postnom;
  var prenom;
  var sexe;
  var date_naissance;
  var lieu_naissance;
  var faculte;
  var departement;
  var id_institution;
  var photo;

  EtudiantModel(this.id_etudiant, this.nom, this.postnom, this.prenom, this.sexe,
      this.date_naissance, this.lieu_naissance, this.faculte, this.departement,
      this.id_institution, this.photo);

  EtudiantModel.fromJson(Map<String, dynamic> json) {
    id_etudiant = json['id_etudiant'];
    nom = json['nom'];
    postnom = json['postnom'];
    prenom = json['prenom'];
    sexe = json['sexe'];
    date_naissance = json['date_naissance'];
    lieu_naissance = json['lieu_naissance'];
    faculte = json['faculte'];
    departement = json['departement'];
    id_institution = json['id_institution'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_etudiant'] = this.id_etudiant;
    data['nom'] = this.nom;
    data['postnom'] = this.postnom;
    data['prenom'] = this.prenom;
    data['sexe'] = this.sexe;
    data['date_naissance'] = this.date_naissance;
    data['lieu_naissance'] = this.lieu_naissance;
    data['faculte'] = this.faculte;
    data['departement'] = this.departement;
    data['id_institution'] = this.id_institution;
    data['photo'] = this.photo;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id_etudiant'] = id_etudiant;
    map['nom'] = nom;
    map['postnom'] = postnom;
    map['prenom'] = prenom;
    map['sexe'] = sexe;
    map['date_naissance'] = date_naissance;
    map['lieu_naissance'] = lieu_naissance;
    map['faculte'] = faculte;
    map['departement'] = departement;
    map['id_institution'] = id_institution;
    map['photo'] = photo;

    return map;
  }

  EtudiantModel.map(dynamic obj) {
    this.id_etudiant = obj["id_etudiant"];
    this.nom = obj["nom"];
    this.postnom = obj["postnom"];
    this.prenom = obj["prenom"];
    this.sexe = obj["sexe"];
    this.date_naissance = obj["date_naissance"];
    this.lieu_naissance = obj["lieu_naissance"];
    this.faculte = obj["faculte"];
    this.departement = obj["departement"];
    this.id_institution = obj["id_institution"];
    this.photo = obj["photo"];
  }
}