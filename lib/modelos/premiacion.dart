class Premiacion {
  String fecha;
  String loteria;
  String sorteo;
  String numero;

  Premiacion({
    required this.fecha,
    required this.loteria,
    required this.sorteo,
    required this.numero,
  });
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'loteria': loteria,
      'sorteo': sorteo,
      'numero': numero,
    };
  }

  Premiacion.fromMap(Map<String, dynamic> map)
      : fecha = map["fecha"],
        loteria = map["loteria"],
        sorteo = map["sorteo"],
        numero = map["numero"];
}
