import 'package:flutter/material.dart';
//import 'package:termostato_2/screens/account_screen.dart';
import 'package:termostato_2/screens/login_screen.dart';
import '../widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';

class ThermostatusScreen extends StatefulWidget {
  const ThermostatusScreen({super.key});

  @override
  State<ThermostatusScreen> createState() => _ThermostatusScreenState();
}

class _ThermostatusScreenState extends State<ThermostatusScreen> {
  double temperature = 22.0;

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
                    /* CircleAvatar( // Aquí tendría que ir el logo de la app
                      radius: 50,
                      backgroundImage: AssetImage('https://static.vecteezy.com/system/resources/previews/018/754/507/original/thermometer-icon-in-gradient-colors-temperature-signs-illustration-png.png'),
                    ), */
                    Text(
                      'Termostato',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              /* ListTile(
                title: const Text(
                  'Termostato',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ), */
              ListTile(
                title: const Text(
                  'Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  ); */
                },
              ),
              ListTile(
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  /* UserService().cleanLocalUser();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  ); */
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 50, 110),
        /* leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ), */
        title: const Text(
          'Termostato',
          style: TextStyle(color: Colors.white),
        ),
        /* actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ], */
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
                    Text('22°C', style: thermostatTextStyle),
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
                    temperature = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.green,
                child:
                    const Icon(Icons.power_settings_new, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
