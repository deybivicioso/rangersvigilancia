import 'package:flutter/material.dart';
import 'FormularioVigilancia.dart'; // Importa la nueva pantalla FormularioVigilancia
import 'VerEmergenciasPage.dart'; // Importa la pantalla VerEmergenciasPage
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Paquete importante para correr la BBDD

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
              Text(
                "Rangers SPD",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón para crear nueva emergencia
                  ElevatedButton(
                    onPressed: () {
                      // Navega a la pantalla de creación de vigilancia (FormularioVigilancia)
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
                          'assets/crear.png', // Ruta de la imagen
                          width: 30, // Tamaño de la imagen
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
                      // Navega a la pantalla de ver emergencias (VerEmergenciasPage)
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
                          'assets/registro.png', // Ruta de la imagen
                          width: 30, // Tamaño de la imagen
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Ver emergencias"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
