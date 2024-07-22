import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeControlScreen extends StatefulWidget {
  @override
  _HomeControlScreenState createState() => _HomeControlScreenState();
}

class _HomeControlScreenState extends State<HomeControlScreen> {
  double _temperature = 22.0;

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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 350,
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
                        Expanded(
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                _temperature =
                                    (_temperature - details.delta.dy * 0.1)
                                        .clamp(15.0, 30.0);
                              });
                            },
                            child: CustomPaint(
                              size: Size(250, 250),
                              painter: TemperatureSliderPainter(_temperature),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Adjust Temperature: ${_temperature.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
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

class TemperatureSliderPainter extends CustomPainter {
  final double temperature;

  TemperatureSliderPainter(this.temperature);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.red],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arcRect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    canvas.drawArc(
      arcRect,
      math.pi,
      math.pi,
      false,
      paint,
    );

    final temperatureAngle = math.pi + ((temperature - 15) / 15) * math.pi;
    final temperatureOffset = Offset(
      size.width / 2 + (size.width / 2 - 10) * math.cos(temperatureAngle),
      size.height / 2 + (size.width / 2 - 10) * math.sin(temperatureAngle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${temperature.toStringAsFixed(1)}°C',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final textOffset = Offset(
      size.width / 2 - textPainter.width / 2,
      size.height / 2 - textPainter.height / 2,
    );

    canvas.drawCircle(temperatureOffset, 10, Paint()..color = Colors.white);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() => runApp(MaterialApp(home: HomeControlScreen()));

Map<String, bool> _lights = {
  'Living Room': false,
  'Bedroom': false,
  'Kitchen': false,
  'Bathroom': false,
};

bool _isFanOn = false;