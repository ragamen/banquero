class Usuario {
  final String email;
  final String password;
  final String nombre;
  final String apellidos;
  final bool activo;
  final String fechanac;
  final String fechainicio;
  final String fechafinal;
  final bool superuser;
//  final String createdat;
//required this.createdat,
//'createdat' : createdat,
//createdat = map["createdat"],
  Usuario(
      {required this.email,
      required this.password,
      required this.nombre,
      required this.apellidos,
      required this.activo,
      required this.fechanac,
      required this.fechainicio,
      required this.fechafinal,
      required this.superuser});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'nombre': nombre,
      'apellidos': apellidos,
      'activo': activo,
      'fechanac': fechanac,
      'fechainicio': fechainicio,
      'fechafinal': fechafinal,
      'superuser': superuser
    };
  }

  Usuario.fromMap(Map<String, dynamic> map)
      : email = map["email"],
        password = map["password"],
        nombre = map["nombre"],
        apellidos = map["apellidos"],
        activo = map["activo"],
        fechanac = map["fechanac"],
        fechainicio = map["fechainicio"],
        fechafinal = map["fechafinal"],
        superuser = map["superuser"];
}
