import 'package:banquero/common.dart';
import 'package:banquero/modelos/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  TextEditingController apellidos = TextEditingController();
  TextEditingController nombres = TextEditingController();
  TextEditingController fechaNac = TextEditingController();

  String? _user = "";
  List<Usuario> usuario = [];
  @override
  void initState() {
    _user = cliente.auth.currentUser?.email;
    // print (_user);
    leerUsuario1();
    // uuario =
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (usuario.isNotEmpty) {
      //   print (usuario.length.toString());
      nombres.text = usuario[0].nombre;
      apellidos.text = usuario[0].apellidos;
      fechaNac.text = usuario[0].fechanac.toString();
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 9, 209, 244),
          title: const Text('Datos Personales ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ))),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 400,
              width: 1.7 * (MediaQuery.of(context).size.width / 3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 209, 244),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xAA6EB1E6),
                    offset: Offset(9, 9),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text("Datos Personales Minimos"),
                  const Divider(color: Colors.lightBlueAccent),
                  TextField(
                    cursorColor: Colors.white,
                    controller: apellidos,
                    /*     onChanged: (value) {
                      if(mounted){
                        setState(() {
                          apellidos.text = value;
                          }
                        );
                      }
                    },*/
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Apellidos',
                        contentPadding: EdgeInsets.all(8)),
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    controller: nombres,
/*                    onChanged: (value) {
                      if(mounted){
                        setState(() {
                          nombres.text = value;
                          }
                        );
                      }
                    },*/
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nombres',
                        contentPadding: EdgeInsets.all(8)),
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    controller: fechaNac,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Fecha de Nacimiento',
                        contentPadding: EdgeInsets.all(8)),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2030));

                      if (pickedDate != null) {
                        //  print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        //  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          fechaNac.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        avisar("Fecha no es seleccionada");
                      }
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await updateUsuario();
                        avisar("Registro actualizado");
                        volver();
                      },
                      child: const Text("Guardar"))
                ],
              ),
            ),
          ),
//  otra columna
          MediaQuery.of(context).size.width < 400.00 &&
                  (MediaQuery.of(context).size.width / 3) > 120
              ? const Text("")
              : Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 600,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 9, 209, 244),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xAA6EB1E6),
                            offset: Offset(9, 9),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Text("Atencion",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18)),
                          Divider(color: Colors.lightBlueAccent),
                          Text(
                            "Los datos solicitados son minimos para fines de "
                            "envio de correos motivados a su cumpleaños y la "
                            "identificacion para envio de notificaciones  de "
                            "nuevas actualizaciones.                          "
                            "Esperamos sea de su agrado el esfuerzo realizado "
                            "para lograr  una  conexion  con  nuestro país en "
                            "cualquier lugar que se encuentren                "
                            "Lo invito a tomar la suscripcion anual de 12USD  "
                            " a los fines de hacer sostenible este proyecto   "
                            "sin publicidad asociada a los contenidos         "
                            "Para fines de servicios y publicidad habra una   "
                            "seccion de servicios muy parecido a las  Paginas "
                            "Amarillas pero no sera intrusivo sino a discreccion"
                            " del Usuario                                      "
                            "No usamos cookies o metodos de seguimiento de sus"
                            " datos, ni deseamos hacerlo                      "
                            " Con ustedes siempre                             ",
                            textAlign: TextAlign.left,
                          ),
                          /*
                    Text("envio de correos motivados a su cumpleaños y la",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    Text("identificacion para envio de notificaciones  de",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    Text("nuevas modificaciones.",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    Text("Esperamos sea de su agrado el esfuerzo realizado",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    Text("para Lograr  una  conexion  con  nuestro país en ",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    Text("cualquier lugar que se encuentren",textAlign:TextAlign.left,style:TextStyle(fontSize: 18)),
                    */
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  leerUsuario1() async {
    usuario = await leerUsuario();
    if (mounted) {
      setState(() {
        usuario = usuario;
      });
    }
    return usuario;
  }

  Future<List<Usuario>> leerUsuario() async {
    //   final supabase = Supabase.instance.client;
    try {
      final data = await cliente.from('usuarios').select().eq('email', _user);
      int count = data.length;
      List<Usuario> usuario = [];
      for (int i = 0; i < count; i++) {
        usuario.add(Usuario.fromMap(data[i]));
      }
      return usuario;
    } catch (e) {
      avisar("Error de lectura");

      return usuario;
    }
  }

  updateUsuario() async {
//    final supabase = Supabase.instance.client;
    await cliente.from('usuarios').update({
      'activo': true,
      'nombre': nombres.text,
      'apellidos': apellidos.text,
      'fechanac': fechaNac.text
    }).match({'email': _user});

    // como cerrar la base de datos
  }

  avisar(String aviso) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(aviso),
      backgroundColor: Colors.redAccent,
    ));
  }

  volver() {
    Navigator.pop(context, true);
  }
}
