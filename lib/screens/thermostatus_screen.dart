// thermostatus.dart
import 'package:flutter/material.dart';
import '../widgets/themes.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Termostato',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
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
                child: const Icon(Icons.power_settings_new, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}