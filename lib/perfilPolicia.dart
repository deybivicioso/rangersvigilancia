import 'package:flutter/material.dart';

class MiPerfilScreen extends StatelessWidget {
  const MiPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto centrada
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/img0.jpg'), // Ruta de tu foto
            ),
            const SizedBox(height: 20),
            // Nombre
            const Text(
              'Deybi Jesús Vicioso Rodríguez',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Matrícula
            const Text(
              'Matrícula: 2022-0030',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
