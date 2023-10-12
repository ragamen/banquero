class ApuestaAgencia {
  String agencia;
  String fecha;
  String loteria;
  String sorteo;
  String numero;
  double jugada;
  double maximo;
  double premio;
  bool activo;
  ApuestaAgencia({
    required this.agencia,
    required this.fecha,
    required this.loteria,
    required this.sorteo,
    required this.numero,
    required this.jugada,
    required this.maximo,
    required this.premio,
    required this.activo,
  });
  Map<String, dynamic> toMap() {
    return {
      'agencia': agencia,
      'fecha': fecha,
      'loteria': loteria,
      'sorteo': sorteo,
      'numero': numero,
      'jugada': jugada,
      'maximo': maximo,
      'premio': premio,
      'activo': activo,
    };
  }

  ApuestaAgencia.fromMap(Map<String, dynamic> map)
      : agencia = map['agencia'],
        fecha = map['fecha'],
        loteria = map["loteria"],
        sorteo = map['sorteo'],
        numero = map['sorteo'],
        jugada = map['jugada'],
        maximo = map['maximo'],
        premio = map['premio'],
        activo = map['activo'];
}
