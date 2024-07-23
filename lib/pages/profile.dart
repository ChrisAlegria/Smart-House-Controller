import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_home_controler/pages/home_page.dart';
import 'package:smart_home_controler/pages/house_control_screen.dart';
import 'package:smart_home_controler/pages/devices_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Profile extends StatelessWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Smart Home Controller',
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
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('House Control'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeControlScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('Connection'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DevicesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido a Smart Home Controller',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              Divider(color: Colors.blueGrey[900], thickness: 2, height: 30),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(imagePath)),
                      ),
                    ),
                    margin: EdgeInsets.only(right: 20),
                    width: 60,
                    height: 60,
                  ),
                  Expanded(
                    child: Text(
                      'Nos da gusto mirarte de nuevo $username!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Esta aplicación te permite controlar tu casa inteligente de forma fácil y conveniente. '
                  'Puedes manejar luces, dispositivos y la temperatura desde tu dispositivo. ¡Disfruta '
                  'de una experiencia integrada y eficiente con nuestro Smart Home Controller!',
                  style: TextStyle(
                      fontSize: 15, height: 1.5, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
