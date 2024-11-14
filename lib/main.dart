import 'package:flutter/material.dart';
import 'FormularioVigilancia.dart'; // Importa la nueva pantalla FormularioVigilancia
import 'VerEmergenciasPage.dart'; // Importa la pantalla VerEmergenciasPage
import 'perfilPolicia.dart'; // Importa la pantalla de perfil
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Paquete para la base de datos

void main() {
  sqfliteFfiInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rangers SPD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.white, Colors.blue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título de la aplicación
              Text(
                "Rangers SPD",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              // Botones principales
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón para crear nueva vigilancia
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormularioVigilancia()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/crear.png',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Crear nueva vigilancia"),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Botón para ver emergencias
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerEmergenciasPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/registro.png',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Ver emergencias"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botón para ver el perfil
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MiPerfilScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 30, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Ver mi perfil",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
