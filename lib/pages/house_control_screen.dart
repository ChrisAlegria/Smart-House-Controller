import 'package:flutter/material.dart';
import 'package:smart_home_controler/pages/devices_screen.dart';
import 'package:smart_home_controler/pages/profile.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smart_home_controler/pages/home_page.dart';
import 'dart:math' as math;
import 'dart:async';

class HomeControlScreen extends StatefulWidget {
  @override
  _HomeControlScreenState createState() => _HomeControlScreenState();
}

class _HomeControlScreenState extends State<HomeControlScreen> {
  double _temperature = 22.0;
  Map<String, bool> _lights = {
    'Living Room': false,
    'Bedroom': false,
    'Kitchen': false,
    'Bathroom': false,
  };
  Map<String, bool> _doors = {
    'Living Room': false,
    'Bedroom': false,
    'Bathroom': false,
  };

  bool _isFanOn = false;
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  Future<void> _connectToBluetooth() async {
    final bluetooth = FlutterBlue.instance;
    final scanSubscription = bluetooth.scan().listen((scanResult) async {
      if (scanResult.device.name == '') {
        await scanResult.device.connect();
        _device = scanResult.device;

        List<BluetoothService> services = await _device!.discoverServices();
        for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString() == '') {
              _characteristic = characteristic;
            }
          }
        }
      }
    });
  }

  Future<void> _sendCommand(String command) async {
    if (_characteristic != null) {
      await _characteristic!.write(command.codeUnits);
    }
  }

  void _updateLight(String room, bool value) {
    setState(() {
      _lights[room] = value;
      _sendCommand(value ? 'LIGHT_ON_$room' : 'LIGHT_OFF_$room');
    });
  }

  void _updateDoor(String door, bool value) {
    setState(() {
      _doors[door] = value;
      _sendCommand(value ? 'DOOR_OPEN_$door' : 'DOOR_CLOSE_$door');
    });
  }

  void _updateTemperature(double temperature) {
    setState(() {
      _temperature = temperature;
      _sendCommand('TEMP_$temperature');
    });
  }

  void _toggleFan() {
    setState(() {
      _isFanOn = !_isFanOn;
      _sendCommand(_isFanOn ? 'FAN_ON' : 'FAN_OFF');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Smart House Controller',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              child: Text(
                'Smart Home Controller',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      '', // Proporciona un valor para username
                      imagePath: '', // Proporciona un valor para imagePath
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('House Control'),
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('Conection'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DevicesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Temperature Control',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 120),
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
                              size: Size(200, 200),
                              painter: TemperatureSliderPainter(_temperature),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Adjust Temperature: ${_temperature.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lights',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: _lights.keys.map((room) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: _buildSwitchControl(
                                  room, _lights[room]!, true),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Fan Control',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFanOn = !_isFanOn;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 50,
                      height: 50,
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
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _isFanOn ? Icons.ac_unit : Icons.ac_unit_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doors',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: _doors.keys.map((door) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: _buildSwitchControl(door, _doors[door]!, false),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchControl(String label, bool value, bool isLight) {
    return SwitchListTile(
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: (bool newValue) {
        setState(() {
          if (isLight) {
            _lights[label] = newValue;
          } else {
            _doors[label] = newValue;
          }
        });
      },
      activeColor: isLight ? Colors.yellow : Colors.blue,
      inactiveThumbColor: Colors.grey[800],
      inactiveTrackColor: Colors.grey[600],
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
      ..strokeWidth = 10
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
      size.width / 2 + (size.width / 2 - 5) * math.cos(temperatureAngle),
      size.height / 2 + (size.width / 2 - 5) * math.sin(temperatureAngle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${temperature.toStringAsFixed(1)}°C',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
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
      10, // Center text at the top of the container
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is TemperatureSliderPainter &&
        oldDelegate.temperature != temperature;
  }
}

void main() {
  runApp(MaterialApp(
      home: HomeControlScreen(), debugShowCheckedModeBanner: false));
}
