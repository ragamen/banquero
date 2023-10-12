import 'package:banquero/common.dart';
import 'package:banquero/helper/apuestafranquicia_helper.dart';
import 'package:banquero/helper/franquicia_helper.dart';
import 'package:banquero/helper/premiacion_helper.dart';
import 'package:banquero/main.dart';
import 'package:banquero/modelos/apuesta_franquicia.dart';
import 'package:banquero/modelos/draw.dart';
import 'package:banquero/modelos/franquicia.dart';
import 'package:banquero/modelos/franquicialista.dart';
import 'package:banquero/modelos/ganador.dart';
import 'package:banquero/modelos/lottery.dart';
import 'package:banquero/modelos/number.dart';
import 'package:banquero/modelos/premiacion.dart';
import 'package:banquero/utils/lotteries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escritorio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  String selectedOption =
      'Agregar Franquicia'; // Opción seleccionada por defecto
  TextEditingController codigoFranquicia = TextEditingController();
  TextEditingController nombreFranquicia = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController banco = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController cedulaadmin = TextEditingController();
  TextEditingController cupo = TextEditingController();
  TextEditingController comision = TextEditingController();
  TextEditingController nroticket = TextEditingController();
  List<ApuestaFranquicia> tabla = [];

  List<Lottery> selectedLotteries = [];
  List<Draw> selectedDraws = [];
  List<Number> selectedNumbers = [];
  DateTime? selectedDate;
  Lottery? selectedLottery;
  Draw? selectedDraw;
  Number? selectedNumber;
  Franquicia? selectedFranquicia;
  List<Franquicia> listaFranquicias = [];
  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  List<Draw> availableDraws = [];
  List<Draw> getAvailableDraws() {
    if (availableDraws.isEmpty) {
      // Realizar alguna acción o devolver un valor predeterminado si la lista está vacía
      return [];
    }

    final now = DateTime.now();
    DateTime fiveMinutesFromNow = now.subtract(const Duration(minutes: 5));
    final filteredDraws = availableDraws.where((draw) {
      final drawTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(draw.name.split(':')[0]),
        int.parse(draw.name.split(':')[1].split(' ')[0]),
      );
      return drawTime.isAfter(fiveMinutesFromNow);
    }).toList();

    return filteredDraws;
  }

  List<Lottery> getAvailableLotteries() {
    if (selectedLottery == null) {
      // Si no se ha seleccionado ninguna lotería, se muestran todas las opciones
      return Loterias.lotteries;
    } else {
      // Si la lotería seleccionada no pertenece a ningún grupo, no se muestran opciones adicionales
      return [selectedLottery!];
    }
  }

  List<Lottery> availableLotteries = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    iniciarFranquicia();

    super.initState();
    leerfranquicias().then((value) {
      setState(() {
        listaFranquicias = FranquiciaActual.franquiciaActual;
        selectedFranquicia =
            listaFranquicias.isNotEmpty ? listaFranquicias[0] : null;
      });
    });
    availableLotteries = getAvailableLotteries();
  }

  void iniciarFranquicia() {
    codigoFranquicia.text = "";
    nombreFranquicia.text = "";
    direccion.text = "";
    correo.text = "";
    banco.text = "";
    telefono.text = "";
    cedulaadmin.text = "";
    cupo.text = "";
    comision.text = "";
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (selectedOption == 'Actualizar Franquicia') {
      if (listaFranquicias.isEmpty) {
        leerfranquicias().then((value) {
          setState(() {
            listaFranquicias = FranquiciaActual.franquiciaActual;
            selectedFranquicia =
                listaFranquicias.isNotEmpty ? listaFranquicias[0] : null;
          });
        });
      }
    } else if (selectedOption == 'Eliminar Franquicia') {
      if (listaFranquicias.isEmpty) {
        leerfranquicias().then((value) {
          setState(() {
            listaFranquicias = FranquiciaActual.franquiciaActual;
            selectedFranquicia =
                listaFranquicias.isNotEmpty ? listaFranquicias[0] : null;
          });
        });
      }
    }
  }

  Widget _buildDataInput() {
    if (selectedOption == 'Agregar Franquicia') {
      iniciarFranquicia();
      listaFranquicias = [];
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: codigoFranquicia,
                decoration:
                    const InputDecoration(labelText: 'Código de Franquicia'),
              ),
              TextField(
                controller: nombreFranquicia,
                decoration:
                    const InputDecoration(labelText: 'Nombre de Franquicia'),
              ),
              TextField(
                controller: direccion,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Escribe el correo';
                  }
                  return null;
                },
                controller: correo,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: banco,
                decoration: const InputDecoration(labelText: 'Banco'),
              ),
              TextField(
                controller: telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: cedulaadmin,
                decoration: const InputDecoration(
                    labelText: 'Cédula del Administrador'),
              ),
              TextField(
                controller: cupo,
                decoration: const InputDecoration(labelText: 'Cupo'),
              ),
              TextField(
                controller: comision,
                decoration: const InputDecoration(labelText: 'Comisión'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Agregar'),
                  onPressed: () {
                    Franquicia franquicia = Franquicia(
                      codigofranquicia: codigoFranquicia.text,
                      nombrefranquicia: nombreFranquicia.text,
                      direccion: direccion.text,
                      correo: correo.text,
                      banco: banco.text,
                      telefono: telefono.text,
                      cedulaadmin: cedulaadmin.text,
                      cupo: double.parse(cupo.text),
                      comision: 0.0,
                    );
                    FranquiciaHelper.createFranquicia(franquicia);
                    iniciarFranquicia();
                    //llamar a agregar o insertar franquicia
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (selectedOption == 'Actualizar Franquicia') {
      if (listaFranquicias.isEmpty) {
        leerfranquicias();
        if (FranquiciaActual.franquiciaActual.isNotEmpty) {
          listaFranquicias = FranquiciaActual.franquiciaActual;
          selectedFranquicia = listaFranquicias[0];
        }
      }
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<Franquicia>(
                value: selectedFranquicia, // Franquicia seleccionada
                hint: const Text(
                  'Selecciona una franquicia',
                  style: TextStyle(
                    color: Color.fromARGB(
                        255, 247, 11, 11), // Cambia el color del texto aquí
                  ),
                ), // Texto de sugerencia
                items: listaFranquicias.map((items) {
                  return DropdownMenuItem<Franquicia>(
                    value: items,
                    child: Text(items.nombrefranquicia),
                  );
                }).toList(),
                onChanged: (items) {
                  setState(() {
                    iniciarFranquicia();
                    selectedFranquicia =
                        items; // Actualizar la franquicia seleccionada
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Buscar'),
                  onPressed: () async {
                    if (selectedFranquicia != null) {
                      codigoFranquicia.text =
                          selectedFranquicia!.codigofranquicia;
                      nombreFranquicia.text =
                          selectedFranquicia!.nombrefranquicia;
                      direccion.text = selectedFranquicia!.direccion;
                      correo.text = selectedFranquicia!.correo;
                      banco.text = selectedFranquicia!.banco;
                      telefono.text = selectedFranquicia!.telefono;
                      cedulaadmin.text = selectedFranquicia!.cedulaadmin;
                      cupo.text = selectedFranquicia!.cupo.toString();
                      comision.text = selectedFranquicia!.comision.toString();
                    }
                    // Lógica para buscar el registro a actualizar
                  },
                ),
              ),
              // Mostrar los campos para actualizar los datos
              TextField(
                controller: nombreFranquicia,
                decoration:
                    const InputDecoration(labelText: 'Nombre de Franquicia'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dirección'),
                controller: direccion,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Escribe el correo';
                  }
                  return null;
                },
                controller: correo,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: banco,
                decoration: const InputDecoration(labelText: 'Banco'),
              ),
              TextField(
                controller: telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: cedulaadmin,
                decoration: const InputDecoration(
                    labelText: 'Cédula del Administrador'),
              ),
              TextField(
                controller: cupo,
                decoration: const InputDecoration(labelText: 'Cupo'),
              ),
              TextField(
                controller: comision,
                decoration: const InputDecoration(labelText: 'Comisión'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Actualizar'),
                  onPressed: () {
                    Franquicia franquicia = Franquicia(
                      codigofranquicia: codigoFranquicia.text,
                      nombrefranquicia: nombreFranquicia.text,
                      direccion: direccion.text,
                      correo: correo.text,
                      banco: banco.text,
                      telefono: telefono.text,
                      cedulaadmin: cedulaadmin.text,
                      cupo: double.parse(cupo.text),
                      comision: double.parse(comision.text),
                    );
                    FranquiciaHelper.updateFranquicia(franquicia);
                    setState(() {
                      iniciarFranquicia();
                      listaFranquicias = [];
                      FranquiciaActual.franquiciaActual = [];
                      leerfranquicias();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (selectedOption == 'Eliminar Franquicia') {
      //  franquicias = FranquiciaActual.franquiciaActual;
      if (listaFranquicias.isEmpty) {
        leerfranquicias();
        if (FranquiciaActual.franquiciaActual.isNotEmpty) {
          listaFranquicias = FranquiciaActual.franquiciaActual;
          selectedFranquicia = listaFranquicias[0];
        }
      }

      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<Franquicia>(
                value: selectedFranquicia, // Franquicia seleccionada
                hint: const Text(
                  'Selecciona una franquicia',
                  style: TextStyle(
                    color: Color.fromARGB(
                        255, 247, 11, 11), // Cambia el color del texto aquí
                  ),
                ), // Texto de sugerencia
                items: listaFranquicias.map((items) {
                  return DropdownMenuItem<Franquicia>(
                    value: items,
                    child: Text(items.nombrefranquicia),
                  );
                }).toList(),
                onChanged: (items) {
                  setState(() {
                    iniciarFranquicia();
                    selectedFranquicia =
                        items; // Actualizar la franquicia seleccionada
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Buscar'),
                  onPressed: () async {
                    if (selectedFranquicia != null) {
                      codigoFranquicia.text =
                          selectedFranquicia!.codigofranquicia;
                      nombreFranquicia.text =
                          selectedFranquicia!.nombrefranquicia;
                      direccion.text = selectedFranquicia!.direccion;
                      correo.text = selectedFranquicia!.correo;
                      banco.text = selectedFranquicia!.banco;
                      telefono.text = selectedFranquicia!.telefono;
                      cedulaadmin.text = selectedFranquicia!.cedulaadmin;
                      cupo.text = selectedFranquicia!.cupo.toString();
                      comision.text = selectedFranquicia!.comision.toString();
                    }
                    // Lógica para buscar el registro a actualizar
                  },
                ),
              ),
              TextField(
                controller: nombreFranquicia,
                decoration:
                    const InputDecoration(labelText: 'Nombre de Franquicia'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dirección'),
                controller: direccion,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Correo'),
                controller: correo,
              ),
              TextField(
                controller: banco,
                decoration: const InputDecoration(labelText: 'Banco'),
              ),
              TextField(
                controller: telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: cedulaadmin,
                decoration: const InputDecoration(
                    labelText: 'Cédula del Administrador'),
              ),
              TextField(
                controller: cupo,
                decoration: const InputDecoration(labelText: 'Cupo'),
              ),
              TextField(
                controller: comision,
                decoration: const InputDecoration(labelText: 'Comisión'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Eliminar'),
                  onPressed: () {
                    codigoFranquicia.text =
                        selectedFranquicia!.codigofranquicia;
                    FranquiciaHelper.deleteFranquicia(codigoFranquicia.text);
                    setState(() {
                      listaFranquicias = [];
                      FranquiciaActual.franquiciaActual = [];
                      iniciarFranquicia();
                      leerfranquicias();
                      listaFranquicias = FranquiciaActual.franquiciaActual;
                      selectedFranquicia = listaFranquicias[0];
                    });

                    // Lógica para eliminar el registro
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (selectedOption == 'Ventas Generales') {
      /* List<ApuestaFranquicia> tabla = [
        ApuestaFranquicia(
          codigofranquicia: 'Agencia 1',
          fecha: 'Fecha 1',
          loteria: 'Loteria 1',
          sorteo: 'Sorteo 1',
          numero: 'Numero 1',
          jugada: 100.0,
          maximo: 100,
          premio: 50,
          activo: true,
        ),
      ];
*/
      Map<String, List<ApuestaFranquicia>> registrosPorFranquicia = {};

      for (var registro in tabla) {
        if (!registrosPorFranquicia.containsKey(registro.codigofranquicia)) {
          registrosPorFranquicia[registro.codigofranquicia] = [];
        }
        registrosPorFranquicia[registro.codigofranquicia]!.add(registro);
      }

      double totalJugada = 0;
      double totalPremio = 0;
      for (var registro in tabla) {
        totalJugada += registro.jugada;
        totalPremio += registro.premio;
      }
      return Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Fecha',
            ),
            controller: TextEditingController(
              text: selectedDate != null
                  ? DateFormat('dd/MM/yy').format(selectedDate!)
                  : '',
            ),
            readOnly: true,
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
              if (selectedDate != null) {
                setState(() async {
                  tabla = await ApuestaFranquiciaHelper.getApfranquicias(
                      selectedDate.toString());
                });
              }
            },
            child: const Row(
              children: [
                Icon(Icons.calendar_today),
                Text('Seleccionar fecha'),
              ],
            ),
          ),
          if (selectedDate != null) ...[
            const SizedBox(height: 16),
            // Mostrar el reporte generado
            Expanded(
              child: ListView(
                children: [
                  for (var codigofranquicia in registrosPorFranquicia.keys)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          codigofranquicia,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        for (var loteria
                            in registrosPorFranquicia[codigofranquicia]!
                                .map((registro) => registro.loteria)
                                .toSet())
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loteria,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              DataTable(
                                columns: const [
                                  DataColumn(label: Text('Sorteo')),
                                  DataColumn(label: Text('Jugada')),
                                  DataColumn(label: Text('Premio')),
                                  DataColumn(label: Text('Diferencia')),
                                ],
                                rows: registrosPorFranquicia[codigofranquicia]!
                                    .where((registro) =>
                                        registro.loteria == loteria)
                                    .map<DataRow>((registro) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(registro.sorteo)),
                                      DataCell(
                                          Text(registro.jugada.toString())),
                                      DataCell(
                                          Text(registro.premio.toString())),
                                      DataCell(Text(
                                          (registro.jugada - registro.premio)
                                              .toString())),
                                    ],
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              // Subtotal por lotería
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Subtotal $loteria:',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Jugada: ${registrosPorFranquicia[codigofranquicia]!.where((registro) => registro.loteria == loteria).map((registro) => registro.jugada).reduce((a, b) => a + b)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Premio: ${registrosPorFranquicia[codigofranquicia]!.where((registro) => registro.loteria == loteria).map((registro) => registro.premio).reduce((a, b) => a + b)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Diferencia: ${registrosPorFranquicia[codigofranquicia]!.where((registro) => registro.loteria == loteria).map((registro) => registro.jugada - registro.premio).reduce((a, b) => a + b)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        // Subtotal por agencia
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subtotal $codigofranquicia:',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Jugada: ${registrosPorFranquicia[codigofranquicia]!.map((registro) => registro.jugada).reduce((a, b) => a + b)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Premio: ${registrosPorFranquicia[codigofranquicia]!.map((registro) => registro.premio).reduce((a, b) => a + b)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Diferencia: ${registrosPorFranquicia[codigofranquicia]!.map((registro) => registro.jugada - registro.premio).reduce((a, b) => a + b)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ),
            // Total general
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total general:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Jugada: $totalJugada',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Premio: $totalPremio',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Diferencia: ${totalJugada - totalPremio}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else if (selectedOption == 'Premiacion') {
      return Column(
        children: [
          /*
          *
          *Comienzo de la premiacion
          *
          */
          const Row(
            children: [
              Text(
                'Lotería',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(width: 205.0),
              Text(
                'Sorteo',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(width: 200.0),
              Text(
                'Número',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 200,
                  child: DropdownButton<Lottery>(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(25, 25)),
                    value: selectedLottery,
                    onChanged: (Lottery? newValue) {
                      setState(() {
                        if (newValue != null) {
                          // Desmarcar todos los elementos seleccionados previamente
                          for (var lottery in selectedLotteries) {
                            lottery.isSelected = false;
                          }
                          // Agregar el nuevo elemento seleccionado
                          selectedLotteries.clear();
                          selectedLotteries.add(newValue);
                          newValue.isSelected = true;
                          selectedLottery = newValue;
                          // Actualizar availableDraws después de seleccionar la primera lotería
                          availableDraws = selectedLottery!.draws;
                          availableDraws = getAvailableDraws();
                          // availableLotteries = getAvailableLotteries();
                        }

//                        availableLotteries = getAvailableLotteries();
                      });
                    },
                    items: availableLotteries.map((Lottery lottery) {
                      return DropdownMenuItem<Lottery>(
                        value: lottery,
                        child: SizedBox(
                          width: 160,
                          child: ListTile(
                            title: Text(lottery.name),
                            trailing: lottery.isSelected
                                ? const Icon(Icons.check)
                                : null,
                            tileColor:
                                lottery.isSelected ? Colors.grey[200] : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    // sorteos
                    child: DropdownButton<Draw>(
                      value: selectedDraw,
                      onChanged: (Draw? newValue) {
                        setState(() {
                          if (newValue != null) {
                            // Desmarcar todos los elementos seleccionados previamente
                            for (var draw in selectedDraws) {
                              draw.isSelected = false;
                            }
                            // Agregar el nuevo elemento seleccionado
                            selectedDraws.clear();
                            selectedDraws.add(newValue);
                            newValue.isSelected = true;
                            selectedDraw = newValue;
                          }
                        });
                      },
                      items: selectedLottery != null
                          ? availableDraws.map((Draw draw) {
                              return DropdownMenuItem<Draw>(
                                value: draw,
                                child: SizedBox(
                                  width: 200,
                                  child: ListTile(
                                    title: Text(draw.name),
                                    trailing: draw.isSelected
                                        ? const Icon(Icons.check)
                                        : null,
                                    tileColor: draw.isSelected
                                        ? const Color.fromARGB(
                                            255, 208, 206, 206)
                                        : null,
                                  ),
                                ),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
// Numeros
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: DropdownButton<Number>(
                      value: selectedNumber,
                      onChanged: (Number? newValue) {
                        setState(() {
                          if (newValue != null) {
                            // Desmarcar todos los elementos seleccionados previamente
                            for (var number in selectedNumbers) {
                              number.isSelected = false;
                            }
                            // Agregar el nuevo elemento seleccionado
                            selectedNumbers.clear();
                            selectedNumbers.add(newValue);
                            newValue.isSelected = true;
                            selectedNumber = newValue;
                          }
                        });
                      },
                      items: selectedDraw != null
                          ? selectedDraw?.numbers.map((Number number) {
                              return DropdownMenuItem<Number>(
                                value: number,
                                child: SizedBox(
                                  width: 200,
                                  child: ListTile(
                                    title: Text(number.value.toString()),
                                    trailing: number.isSelected
                                        ? const Icon(Icons.check)
                                        : null,
                                    tileColor: number.isSelected
                                        ? Colors.grey[200]
                                        : null,
                                  ),
                                ),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 100,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Background color
              ),
              onPressed: () {
                for (Lottery lottery in selectedLotteries) {
                  for (Draw draw in selectedDraws) {
                    for (Number number in selectedNumbers) {
                      Ganador ganador = Ganador(
                        lottery: lottery,
                        draw: draw,
                        number: number,
                      );
                      final xxfecha = DateTime.now();
                      final formato = DateFormat('dd/MM/yyyy');
                      final fechaFormateada = formato.format(xxfecha);
                      var xfecha = fechaFormateada;
                      //           String formatteTime = DateFormat.Hms().format(xxfecha);
                      //var hora = formattedTime;
                      late Premiacion premiacion;
                      premiacion = Premiacion(
                        fecha: xfecha,
                        loteria: ganador.lottery.name,
                        sorteo: ganador.draw.name,
                        numero: ganador.number.value,
                      );
                      PremiacionHelper.createPremiacion(premiacion);
                      PremiacionHelper.updatePremiacionGeneral(premiacion);
                      PremiacionHelper.updatePremiacionFranquicia(premiacion);
                      PremiacionHelper.updatePremiacionAgencia(premiacion);

                      setState(() {});
                    }
                  }
                }

                for (Lottery lottery in selectedLotteries) {
                  lottery.isSelected = false;
                }

                for (Draw draw in selectedDraws) {
                  draw.isSelected = false;
                }

                for (Number number in selectedNumbers) {
                  number.isSelected = false;
                }
                setState(() {
                  availableLotteries = getAvailableLotteries();
                });
              },
              child: const Text(
                'Agregar a la lista de compras',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
/*
*
*Funal de la premiacion
*/
        ],
      );
    } else if (selectedOption == 'Opción 6') {
      return const Column(
        children: [
          Text('Contenido de la Opción 6'),
        ],
      );
    } else if (selectedOption == 'Opción 7') {
      return const Column(
        children: [
          Text('Contenido de la Opción 7'),
        ],
      );
    } else if (selectedOption == 'Opción 8') {
      return const Column(
        children: [
          Text('Contenido de la Opción 8'),
        ],
      );
    } else {
      return Container();
    }
  }

  leerfranquicias() async {
    await FranquiciaHelper.getfranquicias01();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lotoplay                                                                                     Escritorio',
          style: TextStyle(color: Colors.amber, fontSize: 30),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Agregar Franquicia'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Agregar Franquicia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Agregar Franquicia'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Actualizar Franquicia'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Actualizar Franquicia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                selectedOption == 'Actualizar Franquicia'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Eliminar Franquicia'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Eliminar Franquicia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Eliminar Franquicia'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Ventas Generales'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Ventas Generales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Ventas Generales'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Premiacion'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Premiacion',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Premiacion'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Opción 6'),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color: const Color.fromARGB(255, 77, 75, 74)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Text(
                            'Opción 6',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: selectedOption == 'Opción 6'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Opción 7'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Opción 7',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Opción 7'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectOption('Opción 8'),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(255, 77, 75, 74)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          'Opción 8',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedOption == 'Opción 8'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 6.0), // Ajusta el valor de padding aquí
              // padding: const EdgeInsets.all(6.0),
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(255, 60, 232, 121)),
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: _buildDataInput()),
            ),
          ),
        ],
      ),
    );
  }
}

class EndSession extends StatelessWidget {
  const EndSession({super.key});

  @override
  Widget build(BuildContext context) {
    cliente.auth.signOut();
    return const MyWidget();
  }
}
