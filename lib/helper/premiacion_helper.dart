import 'package:banquero/common.dart';
import 'package:banquero/modelos/apuesta_agencia.dart';
import 'package:banquero/modelos/apuesta_general.dart';
import 'package:banquero/modelos/premiacion.dart';

class PremiacionHelper {
  static Future<Premiacion> getPremiacion(Premiacion premiacion1) async {
    final response = await cliente
        .from('premiacion')
        .select('fecha,loteria,sorteo,numero')
        .eq('fecha', premiacion1.fecha)
        .eq('loteria', premiacion1.loteria)
        .eq('sorteo', premiacion1.sorteo);
    Premiacion premiacion = Premiacion.fromMap(response[0]);
    return premiacion;
  }

  static Future<void> createPremiacion(Premiacion premiacion) async {
    await cliente.from('premiacion').insert([
      {
        'fecha': premiacion.fecha,
        'loteria': premiacion.loteria,
        'sorteo': premiacion.sorteo,
        'numero': premiacion.numero,
      }
    ]);
  }

  static Future<void> deletePremiacion(
      String fecha, String loteria, String sorteo) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('premiacion')
        .delete()
        .eq('fecha', fecha)
        .eq('loteria', loteria)
        .eq('sorteo', sorteo);
  }

  static Future<void> updatePremiacion(Premiacion premiacion) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('premiacion')
        .update({
          'fecha': premiacion.fecha,
          'loteria': premiacion.loteria,
          'sorteo': premiacion.sorteo,
          'numero': premiacion.numero,
        })
        .eq('fecha', premiacion.fecha)
        .eq('loteria', premiacion.loteria)
        .eq('sorteo', premiacion.sorteo);
  }

  static Future<void> updatePremiacionGeneral(Premiacion premiacion) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestageneral')
        .select('agencia,fecha,loteria,sorteo,numero,jugada,maximo,premio')
        .eq('fecha', premiacion.fecha)
        .eq('loteria', premiacion.loteria)
        .eq('sorteo', premiacion.sorteo)
        .eq('numero', premiacion.numero);
    var count = response.length;
    List<ApuestaGeneral> lista = [];
    for (int i = 0; i < count; i++) {
      lista[i] = ApuestaGeneral.fromMap(response[i]);
    }

    if (lista.isNotEmpty) {
      count = lista.length;
      for (int i = 0; i < count; i++) {
        lista[i].premio = lista[i].jugada * 30;
        await cliente
            .from('apuestageneral')
            .update({'premio': lista[i].premio})
            .eq('fecha', lista[i].fecha)
            .eq('loteria', lista[i].loteria)
            .eq('sorteo', lista[i].sorteo)
            .eq('numero', lista[i].numero);
      }
    }
  }

  static Future<void> updatePremiacionAgencia(Premiacion premiacion) async {
    // ignore: unused_local_variable
    final response = await cliente
        .from('apuestaagencia')
        .select('agencia,fecha,loteria,sorteo,numero,jugada,maximo,premio')
        .eq('fecha', premiacion.fecha)
        .eq('loteria', premiacion.loteria)
        .eq('sorteo', premiacion.sorteo)
        .eq('numero', premiacion.numero);
    var count = response.length;
    List<ApuestaAgencia> lista = [];
    for (int i = 0; i < count; i++) {
      lista[i] = ApuestaAgencia.fromMap(response[i]);
    }

    if (lista.isNotEmpty) {
      count = lista.length;
      for (int i = 0; i < count; i++) {
        lista[i].premio = lista[i].jugada * 30;
        await cliente
            .from('apuestaagencia')
            .update({'premio': lista[i].premio})
            .eq('fecha', lista[i].fecha)
            .eq('loteria', lista[i].loteria)
            .eq('sorteo', lista[i].sorteo)
            .eq('numero', lista[i].numero);
      }
    }
  }
}
