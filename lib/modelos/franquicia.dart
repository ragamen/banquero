class Franquicia {
  String codigofranquicia;
  String nombrefranquicia;
  String direccion;
  String correo;
  String banco;
  String telefono;
  String cedulaadmin;
  double cupo;
  double comision;

  Franquicia({
    required this.codigofranquicia,
    required this.nombrefranquicia,
    required this.direccion,
    required this.correo,
    required this.banco,
    required this.telefono,
    required this.cedulaadmin,
    required this.cupo,
    required this.comision,
  });
  Map<String, dynamic> toMap() {
    return {
      'codigofranquicia': codigofranquicia,
      'nombrefranquicia': nombrefranquicia,
      'direccion': direccion,
      'correo': correo,
      'banco': banco,
      'telefono': telefono,
      'cedulaadmin': cedulaadmin,
      'cupo': cupo,
      'comision': comision
    };
  }

  Franquicia.fromMap(Map<String, dynamic> map)
      : codigofranquicia = map["codigofranquicia"],
        nombrefranquicia = map["nombrefranquicia"],
        direccion = map["direccion"],
        correo = map["correo"],
        banco = map["banco"],
        telefono = map["telefono"],
        cedulaadmin = map["cedulaadmin"],
        cupo = map["cupo"],
        comision = map["comision"];
}
