class TravailModel {
  var id_travail;
  var id_etudiant;
  var id_institution;
  var sujet;
  var categorie;
  var directeur;
  var encadreur;

  TravailModel(this.id_travail, this.id_etudiant, this.id_institution, this.sujet,
      this.categorie, this.directeur, this.encadreur);

  TravailModel.fromJson(Map<String, dynamic> json) {
    id_travail = json['id_travail'];
    id_etudiant = json['id_etudiant'];
    id_institution = json['id_institution'];
    sujet = json['sujet'];
    categorie = json['categorie'];
    directeur = json['directeur'];
    encadreur = json['encadreur'];
    id_institution = json['id_institution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_travail'] = this.id_travail;
    data['id_etudiant'] = this.id_etudiant;
    data['id_institution'] = this.id_institution;
    data['sujet'] = this.sujet;
    data['categorie'] = this.categorie;
    data['directeur'] = this.directeur;
    data['encadreur'] = this.encadreur;
    data['id_institution'] = this.id_institution;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id_travail'] = id_travail;
    map['id_etudiant'] = id_etudiant;
    map['id_institution'] = id_institution;
    map['sujet'] = sujet;
    map['categorie'] = categorie;
    map['directeur'] = directeur;
    map['encadreur'] = encadreur;
    map['id_institution'] = id_institution;

    return map;
  }

  TravailModel.map(dynamic obj) {
    this.id_travail = obj["id_travail"];
    this.id_etudiant = obj["id_etudiant"];
    this.id_institution = obj["id_institution"];
    this.sujet = obj["sujet"];
    this.categorie = obj["categorie"];
    this.directeur = obj["directeur"];
    this.encadreur = obj["encadreur"];
    this.id_institution = obj["id_institution"];
  }
}