import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Container(
          width: orientation == Orientation.portrait
              ? screenSize.width * 0.8
              : screenSize.width * 0.6,
          height: screenSize.height * 0.5,
          color: Colors.blue,
          child: Center(
            child: Text(
              'Welcome to Smart Home Control',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
