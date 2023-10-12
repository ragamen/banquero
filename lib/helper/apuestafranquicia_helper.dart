import 'package:banquero/common.dart';
import 'package:banquero/modelos/apuesta_franquicia.dart';

class ApuestaFranquiciaHelper {
  static Future<List<ApuestaFranquicia>> getApfranquicias(String fecha) async {
    final response = await cliente
        .from('apuestafranquicias')
        .select(
            'codigofranquicia,fecha,loteria,sorteo,numero,jugada,maximo,premio')
        .eq('fecha', fecha);
    List<ApuestaFranquicia> apuestaFranquicia = [];
    var count = response.length;
    for (int i = 0; i < count; i++) {
      apuestaFranquicia[i] = ApuestaFranquicia.fromMap(response[i]);
    }
    return apuestaFranquicia;
  }
}
