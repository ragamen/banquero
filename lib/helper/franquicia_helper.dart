import 'package:banquero/common.dart';
import 'package:banquero/modelos/franquicia.dart';
import 'package:banquero/modelos/franquicialista.dart';

class FranquiciaHelper {
  static Future<Franquicia> getfranquicias(String codfranquicia) async {
    final response = await cliente
        .from('franquicias')
        .select(
            'codigofranquicia,nombrefranquicia,direccion,correo,banco,telefono,cedulaadmin,cupo,comision,nroticket,serial')
        .eq('codigofranquicia', codfranquicia);
    Franquicia franquicia = Franquicia.fromMap(response[0]);
    return franquicia;
  }

  static getfranquicias01() async {
    try {
      final response = await cliente.from('franquicias').select(
          'codigofranquicia,nombrefranquicia,direccion,correo,banco,telefono,cedulaadmin,cupo,comision');
      int count = response.length;
      List<Franquicia> franquicia = [];
      for (int i = 0; i < count; i++) {
        franquicia.add(Franquicia.fromMap(response[i]));
      }
      FranquiciaActual.franquiciaActual = franquicia;
    } catch (e) {
      //}
    }
  }

  static Future<void> createFranquicia(Franquicia franquicia) async {
    await cliente.from('franquicias').insert([
      {
        'codigofranquicia': franquicia.codigofranquicia,
        'nombrefranquicia': franquicia.nombrefranquicia,
        'direccion': franquicia.direccion,
        'correo': franquicia.correo,
        'banco': franquicia.banco,
        'telefono': franquicia.telefono,
        'cedulaadmin': franquicia.cedulaadmin,
        'cupo': franquicia.cupo,
        'comision': franquicia.comision,
      }
    ]);
  }

  static Future<void> deleteFranquicia(String codigofranquicia) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('franquicias')
        .delete()
        .eq('codigofranquicia', codigofranquicia);
  }

  static Future<void> updateFranquicia(Franquicia franquicia) async {
    // ignore: unused_local_variable
    final response = await cliente.from('franquicias').update({
      'nombrefranquicia': franquicia.nombrefranquicia,
      'direccion': franquicia.direccion,
      'correo': franquicia.correo,
      'banco': franquicia.banco,
      'telefono': franquicia.telefono,
      'cedulaadmin': franquicia.cedulaadmin,
      'cupo': franquicia.cupo,
      'comision': franquicia.comision,
    }).eq('codigofranquicia', franquicia.codigofranquicia);
  }
}
