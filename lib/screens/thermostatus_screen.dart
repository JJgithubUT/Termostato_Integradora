import 'package:flutter/material.dart';
import 'package:termostato_2/models/device_model.dart'; // Asegúrate de que esta clase tenga los campos correctos
import 'package:termostato_2/models/dynamic_device_model.dart';
import 'package:termostato_2/screens/account_screen.dart';
// import '../widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';
import 'package:termostato_2/services/validation_service.dart';

class ThermostatusScreen extends StatefulWidget {
  const ThermostatusScreen({super.key});

  @override
  State<ThermostatusScreen> createState() => _ThermostatusScreenState();
}

class _ThermostatusScreenState extends State<ThermostatusScreen> {
  final CloudFirestoreService _dbService = CloudFirestoreService();
  double temperature = 20.0; // Inicializa con el valor que recibas de Firebase
  // Variable para almacenar los datos dinámicos del dispositivo
  DynamicDeviceModel? dynamicDevice;
  DeviceModel? device;

  final TextEditingController _codigoeditingController =
      TextEditingController();
  final TextEditingController _correoeditingController =
      TextEditingController();
  final TextEditingController _nombreeditingController =
      TextEditingController();
  final TextEditingController _codigoControllerForUpdate =
      TextEditingController();
  final TextEditingController _nombreControllerForUpdate =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDevice();
  }

  Future<void> _initializeDevice() async {
    await _getDevice();
    if (device != null) {
      _getDynamicDevice();
    }
  }

  // Obtén la información estática del dispositivo
  Future<void> _getDevice() async {
    device = await CloudFirestoreService().getDevice(context);
    // ignore: avoid_print
    print(
      '_getDevice(), thermo_screen | Device: / ${device!.id} / ${device!.codigo} / ${device!.correo} / ${device!.estado} / ${device!.nombre} /',
    );
    if (device != null) {
      _codigoeditingController.text = device!.codigo;
      _correoeditingController.text = device!.correo;
      _nombreeditingController.text = device!.nombre;
      _codigoControllerForUpdate.text = device!.codigo;
      _nombreControllerForUpdate.text = device!.nombre;
      setState(() {});
    }
  }

  Future<void> _updateDevice() async {
    try {
      if (device != null &&
          ValidationService().idValidCode(_codigoControllerForUpdate.text) &&
          ValidationService().isValidName(_nombreControllerForUpdate.text)) {
        CloudFirestoreService().updateDevice(
          device: DeviceModel(
            id: device!.id,
            codigo: _codigoControllerForUpdate.text,
            correo: device!.codigo,
            estado: device!.estado,
            nombre: _nombreControllerForUpdate.text,
          ),
          context: context,
        );
        _initializeDevice();
        Navigator.of(context).pop();
      } else {
        CloudFirestoreService().showSnapMessage(
          context: context,
          message: 'Error en alguno de los campos',
          duration: Duration(seconds: 5),
        );
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  // Escuchar los cambios de temperatura en tiempo real
  void _getDynamicDevice() {
    try {
      // ignore: avoid_print
      print(
        '_getDynamicDevice(), thermo_screen | device!.codigo: ${device!.codigo}',
      );
      _dbService.getDynamicDevice(device!.codigo).listen((dynamicDeviceData) {
        setState(() {
          dynamicDevice = dynamicDeviceData;
          if (dynamicDevice != null) {
            temperature = dynamicDevice!.tempObjetivo;
          }
        });
      });
    } catch (e) {
      CloudFirestoreService().showSnapMessage(
        context: context,
        message: 'Dispositivo no encontrado',
        duration: Duration(seconds: 5),
        color: Colors.limeAccent,
      );
    }
  }

  // Actualiza la temperatura objetivo en Firebase
  Future<void> _updateTemperature() async {
    if (device != null && device!.codigo.isNotEmpty) {
      try {
        // Escucha la información del dispositivo usando tu servicio existente
        _dbService.getDynamicDevice(device!.codigo).listen((dynamicDeviceData) {
          if (dynamicDeviceData != null) {
            // Si el dispositivo existe, actualiza la temperatura
            CloudFirestoreService().updateDynamicDevice(
              device!.codigo,
              temperature, // Actualiza la temperatura objetivo
              // ignore: use_build_context_synchronously
              context,
            );
          } else {
            // Si el dispositivo no existe, muestra un mensaje de error
            CloudFirestoreService().showSnapMessage(
              // ignore: use_build_context_synchronously
              context: context,
              message: 'El dispositivo no existe en la base de datos',
              duration: Duration(seconds: 5),
              color: Colors.redAccent,
            );
          }
        });
      } catch (e) {
        // Maneja posibles errores en el flujo
        CloudFirestoreService().showSnapMessage(
          context: context,
          message: 'Error al verificar el dispositivo',
          duration: Duration(seconds: 5),
          color: Colors.redAccent,
        );
      }
    } else {
      CloudFirestoreService().showSnapMessage(
        context: context,
        message: 'Código de dispositivo vacío',
        duration: Duration(seconds: 5),
        color: Colors.orangeAccent,
      );
    }
  }

  // Función para mostrar el dialogo de edición
  void showDialogEdit() {
    /* _getDevice(); */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
          ),
          backgroundColor: Color(0xFF133C55), // Fondo igual que el Drawer
          title: Center(
            child: Text(
              'Edita tu dispositivo',
              style: TextStyle(
                color: Color(0xFF91E5F6),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codigoControllerForUpdate,
                style: TextStyle(color: Color(0xFF91E5F6)), // Estilo del texto
                decoration: InputDecoration(
                  labelText: 'Código del dispositivo',
                  labelStyle: TextStyle(
                    color: Color(0xFF84D2F6),
                  ), // Color del label
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF84D2F6)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF91E5F6)),
                  ),
                ),
              ),
              TextField(
                controller: _nombreControllerForUpdate,
                style: TextStyle(color: Color(0xFF91E5F6)), // Estilo del texto
                decoration: InputDecoration(
                  labelText: 'Ubicación del dispositivo',
                  labelStyle: TextStyle(
                    color: Color(0xFF84D2F6),
                  ), // Color del label
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF84D2F6)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF91E5F6)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateDevice();
              },
              child: Text(
                'Editar',
                style: TextStyle(
                  color: Color(0xFF91E5F6), // Estilo del botón
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFF84D2F6), // Estilo del botón
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF133C55), // Azul oscuro
                Color(0xFF386FA4), // Azul intermedio
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Climatic',
                    style: TextStyle(
                      color: Color(0xFF91E5F6),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ), // Ícono agregado
                title: Text(
                  'Cuenta',
                  style: TextStyle(color: Color(0xFF84D2F6)),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              AccountScreen(), // Redirige a la pantalla de cuenta
                    ),
                  );
                },
              ),
              /* ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ), // Otro ícono agregado
                title: const Text(
                  'Configuración',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navegar a la pantalla de configuración
                },
              ), */
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF133C55),
        title: Text('Termostato', style: TextStyle(color: Color(0xFF91E5F6))),
        iconTheme: IconThemeData(
          color: Color(0xFF91E5F6), // Cambia el color del ícono aquí.
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF133C55), Color(0xFF386FA4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _nombreeditingController.text,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  /* color: Color(0xFF91E5F6), */
                  color: Color(0xFF91E5F6),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFF59A5D8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${dynamicDevice?.tempActual ?? 'Cargando...'}°C',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        /* color: Color(0xFF91E5F6), */
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Objetivo: ${temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 20,
                        /* color: Color(0xFF84D2F6) */ color: Color.fromARGB(
                          255,
                          192,
                          235,
                          255,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Slider(
                value: temperature,
                min: 10,
                max: 30,
                divisions: 20,
                label: temperature.toStringAsFixed(1),
                activeColor: Color(0xFF386FA4),
                inactiveColor: Color(0xFF84D2F6),
                onChanged: (value) {
                  setState(() {
                    temperature = value;
                  });
                  _updateTemperature();
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  showDialogEdit();
                },
                backgroundColor: Color(0xFF133C55),
                child: const Icon(Icons.settings, color: Color(0xFF91E5F6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
