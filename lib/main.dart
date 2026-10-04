import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() {
  runApp(const PlanetCompassApp());
}

class PlanetCompassApp extends StatelessWidget {
  const PlanetCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planet Compass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CompassScreen(),
    );
  }
}

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  // Sample approximate azimuths for demo purposes (Degrees from True North)
  final Map<String, double> planets = {
    'Venus': 45.0,
    'Mars': 120.0,
    'Jupiter': 210.0,
    'Saturn': 300.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planet Compass'),
        centerTitle: true,
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error reading heading: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? heading = snapshot.data?.heading;

          if (heading == null) {
            return const Center(
              child: Text('Device does not have magnetic sensor / compass.'),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${heading.toStringAsFixed(1)}°',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 3),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Compass Dial
                      Transform.rotate(
                        angle: (heading * (math.pi / 180) * -1),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Positioned(
                              top: 10,
                              child: Text('N', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                            ),
                            ...planets.entries.map((entry) {
                              final rad = entry.value * (math.pi / 180);
                              return Transform.rotate(
                                angle: rad,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      // Fixed Direction Indicator
                      const Icon(Icons.arrow_drop_up, size: 50, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
