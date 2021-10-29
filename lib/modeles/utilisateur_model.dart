class UtilisateurModel {
  var id_utilisateur;
  var nom_utilisateur;
  var mot_de_passe;
  var niveau_utilisateur;

  UtilisateurModel(this.id_utilisateur, this.nom_utilisateur, this.mot_de_passe, this.niveau_utilisateur);

  UtilisateurModel.fromJson(Map<String, dynamic> json) {
    id_utilisateur = json['id_utilisateur'];
    nom_utilisateur = json['nom_utilisateur'];
    mot_de_passe = json['mot_de_passe'];
    niveau_utilisateur = json['niveau_utilisateur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_utilisateur'] = this.id_utilisateur;
    data['nom_utilisateur'] = this.nom_utilisateur;
    data['mot_de_passe'] = this.mot_de_passe;
    data['niveau_utilisateur'] = this.niveau_utilisateur;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id_utilisateur'] = id_utilisateur;
    map['nom_utilisateur'] = nom_utilisateur;
    map['mot_de_passe'] = mot_de_passe;
    map['niveau_utilisateur'] = niveau_utilisateur;

    return map;
  }

  UtilisateurModel.map(dynamic obj) {
    this.id_utilisateur = obj["id_utilisateur"];
    this.nom_utilisateur = obj["nom_utilisateur"];
    this.mot_de_passe = obj["mot_de_passe"];
    this.niveau_utilisateur = obj["niveau_utilisateur"];
  }
}