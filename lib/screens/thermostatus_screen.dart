import 'package:flutter/material.dart';
import 'package:termostato_2/models/device_model.dart'; // Asegúrate de que esta clase tenga los campos correctos
import 'package:termostato_2/models/dynamic_device_model.dart';
import 'package:termostato_2/screens/account_screen.dart';
import '../widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';

class ThermostatusScreen extends StatefulWidget {
  const ThermostatusScreen({super.key});

  @override
  State<ThermostatusScreen> createState() => _ThermostatusScreenState();
}

class _ThermostatusScreenState extends State<ThermostatusScreen> {
  final CloudFirestoreService _dbService = CloudFirestoreService();
  double temperature = 20.0; // Inicializa con el valor que recibas de Firebase
  DeviceModel? device;

  final TextEditingController _codigoeditingController =
      TextEditingController();
  final TextEditingController _correoeditingController =
      TextEditingController();
  final TextEditingController _nombreeditingController =
      TextEditingController();

  // Variable para almacenar los datos dinámicos del dispositivo
  DynamicDeviceModel? dynamicDevice;

  @override
  void initState() {
    super.initState();
    _getDynamicDevice();
    /* _initializeDevice(); */
  }

  /* Future<void> _initializeDevice() async {
    await _getDevice();
    if (device != null) {
      _getDynamicDevice();
    }
  } */

  // Obtén la información estática del dispositivo
  Future<void> _getDevice() async {
    device = await CloudFirestoreService().getDevice(context);
    if (device != null) {
      _codigoeditingController.text = device!.codigo;
      _correoeditingController.text = device!.correo;
      _nombreeditingController.text = device!.nombre;
    }
  }

  // Escuchar los cambios de temperatura en tiempo real
  void _getDynamicDevice() {
    _dbService.getDynamicDevice('esp32trycsrp133').listen((dynamicDeviceData) {
      setState(() {
        dynamicDevice = dynamicDeviceData;
        if (dynamicDevice != null) {
          temperature = dynamicDevice!.tempObjetivo;
        }
      });
    });
  }

  // Actualiza la temperatura objetivo en Firebase
  Future<void> _updateDevice() async {
    CloudFirestoreService().updateDynamicDevice(
      'esp32trycsrp133',
      temperature, // Actualiza la temperatura objetivo
      context
    );
    
  }

  // Función para mostrar el dialogo de edición
  void showDialogEdit() {
    /* _getDevice(); */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edita tu dispositivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codigoeditingController,
                decoration: const InputDecoration(labelText: 'Código de placa'),
              ),
              TextField(
                controller: _nombreeditingController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación del dispositivo',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateDevice();
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
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
          color: const Color.fromARGB(255, 75, 59, 113),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 75, 59, 113),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Climatic',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text(
                  'Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navegar a la pantalla de cuenta
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(), /////////////////////////////////// Aquí va este pedo de la cuenta
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 50, 110),
        title: const Text('Termostato', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: thermostatContainerDecoration,
                child: Column(
                  children: [
                    // Mostrar la temperatura actual obtenida desde Firebase
                    Text(
                      '${dynamicDevice?.tempActual ?? 'Cargando...'}°C',
                      style: thermostatTextStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Objetivo: ${temperature.toStringAsFixed(1)}°C',
                      style: targetTempTextStyle,
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
                activeColor: sliderActiveColor,
                inactiveColor: sliderInactiveColor,
                onChanged: (value) {
                  setState(() {
                    temperature = value; // Actualiza el valor del slider
                  });
                  _updateDevice(); // Actualiza Firebase con el nuevo objetivo
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
