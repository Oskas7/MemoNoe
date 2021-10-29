class InstitutionModel {
  var id_institution;
  var designation;
  var adresse;
  var devise;
  var logo;

  InstitutionModel(this.id_institution, this.designation, this.adresse, this.devise, this.logo);

  InstitutionModel.fromJson(Map<String, dynamic> json) {
    id_institution = json['id_institution'];
    designation = json['designation'];
    adresse = json['adresse'];
    devise = json['devise'];
    logo = json['logo'];
    id_institution = json['id_institution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_institution'] = this.id_institution;
    data['designation'] = this.designation;
    data['adresse'] = this.adresse;
    data['devise'] = this.devise;
    data['logo'] = this.logo;
    data['id_institution'] = this.id_institution;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id_institution'] = id_institution;
    map['designation'] = designation;
    map['adresse'] = adresse;
    map['devise'] = devise;
    map['logo'] = logo;
    map['id_institution'] = id_institution;

    return map;
  }

  InstitutionModel.map(dynamic obj) {
    this.id_institution = obj["id_institution"];
    this.designation = obj["designation"];
    this.adresse = obj["adresse"];
    this.devise = obj["devise"];
    this.logo = obj["logo"];
    this.id_institution = obj["id_institution"];
  }
}