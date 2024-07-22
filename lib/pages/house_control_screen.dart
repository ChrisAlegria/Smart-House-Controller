import 'package:flutter/material.dart';

class HomeControlScreen extends StatefulWidget {
  @override
  _HomeControlScreenState createState() => _HomeControlScreenState();
}

class _HomeControlScreenState extends State<HomeControlScreen> {
  double _temperature = 22.0;
  bool _isFanOn = false;
  Map<String, bool> _lights = {
    'Bedroom': false,
    'Kitchen': false,
    'Living Room': false,
    'Bathroom': false,
  };

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Smart Home Controller',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 20),
            // Filas para temperatura y luces
            Row(
              children: [
                // Contenedor para temperatura
                Expanded(
                  child: Container(
                    height: 350, // Ajustar la altura al tamaño deseado
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Temperature Control',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: (_temperature - 15) / 15,
                                strokeWidth: 10,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.tealAccent),
                              ),
                            ),
                            Text(
                              '${_temperature.toStringAsFixed(1)}°C',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    _temperature =
                                        (_temperature - details.delta.dy * 0.1)
                                            .clamp(15.0, 30.0);
                                  });
                                },
                                child: Container(
                                  width: 180,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.tealAccent,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Slide to Adjust Temperature',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Contenedor para luces
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lights',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: _lights.keys.map((room) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: _buildLightControl(room, _lights[room]!),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Contenedor para ventiladores
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Fan Control',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFanOn = !_isFanOn;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _isFanOn ? Colors.tealAccent : Colors.grey[800]!,
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _isFanOn ? Colors.tealAccent : Colors.grey[800]!,
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _isFanOn ? Icons.ac_unit : Icons.ac_unit_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightControl(String room, bool isLightOn) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _lights[room] = !isLightOn;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isLightOn ? Colors.yellow[700] : Colors.grey[800]!,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              isLightOn ? Colors.yellow[700]! : Colors.grey[800]!,
              Colors.black.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              room,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
