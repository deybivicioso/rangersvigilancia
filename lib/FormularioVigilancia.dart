import 'package:flutter/material.dart';
import 'package:rangersvigilancia/databasehelper.dart';
//import 'DatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormularioVigilancia extends StatefulWidget {
  @override
  _FormularioVigilanciaState createState() => _FormularioVigilanciaState();
}

class _FormularioVigilanciaState extends State<FormularioVigilancia> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  File? _foto;
  File? _audio;

  // Método para seleccionar una imagen desde la galería
  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  // Método para grabar audio (implementación simplificada)
  Future<void> _grabarAudio() async {
    // Aquí puedes agregar la lógica para grabar audio usando un paquete como 'flutter_sound'
    // Por simplicidad, solo mostramos un mensaje en este ejemplo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidad de grabar audio aún no implementada')),
    );
  }

  // Método para guardar los datos en la base de datos
  void _guardarDatos() async {
    if (_formKey.currentState!.validate()) {
      // Inicializa la base de datos
      await _databaseHelper.database;

      // Obtiene los datos del formulario
      final titulo = _tituloController.text;
      final fecha = _fechaController.text;
      final descripcion = _descripcionController.text;

      // Convierte la imagen y el audio a bytes
      final fotoBytes = _foto != null ? await _foto!.readAsBytes() : null;
      final audioBytes = _audio != null ? await _audio!.readAsBytes() : null;

      // Crea un mapa con los datos para insertar en la base de datos
      Map<String, dynamic> vigilancia = {
        'titulo': titulo,
        'fecha': fecha,
        'descripcion': descripcion,
        'foto': fotoBytes,
        'audio': audioBytes,
      };

      // Inserta los datos en la base de datos
      await _databaseHelper.insertVigilancia(vigilancia);

      // Muestra un mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos guardados correctamente')),
      );

      // Limpia los campos después de guardar
      _tituloController.clear();
      _fechaController.clear();
      _descripcionController.clear();
      setState(() {
        _foto = null;
        _audio = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Datos de Vigilancia'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _seleccionarImagen,
                child: Text('Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
              if (_foto != null) Image.file(_foto!, height: 100),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _grabarAudio,
                child: Text('Grabar Audio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _guardarDatos,
                child: Text('Guardar Datos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


