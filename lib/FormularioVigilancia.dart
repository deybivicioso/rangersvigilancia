import 'package:flutter/material.dart';
import 'package:rangersvigilancia/databasehelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  File? _foto;
  File? _audio;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  // Inicializar el grabador y solicitar permisos
  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder.openRecorder();
  }

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

  // Método para grabar o detener el audio
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _audioPath = path;
        _audio = File(path!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grabación detenida')),
      );
    } else {
      await _recorder.startRecorder(
        toFile: 'audio_record.aac',
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grabando audio...')),
      );
    }
  }

  // Método para guardar los datos en la base de datos
  void _guardarDatos() async {
    if (_formKey.currentState!.validate()) {
      await _databaseHelper.database;

      final titulo = _tituloController.text;
      final fecha = _fechaController.text;
      final descripcion = _descripcionController.text;

      final fotoBytes = _foto != null ? await _foto!.readAsBytes() : null;
      final audioBytes = _audio != null ? await _audio!.readAsBytes() : null;

      Map<String, dynamic> vigilancia = {
        'titulo': titulo,
        'fecha': fecha,
        'descripcion': descripcion,
        'foto': fotoBytes,
        'audio': audioBytes,
      };

      await _databaseHelper.insertVigilancia(vigilancia);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos guardados correctamente')),
      );

      _tituloController.clear();
      _fechaController.clear();
      _descripcionController.clear();
      setState(() {
        _foto = null;
        _audio = null;
        _audioPath = null;
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
                onPressed: _toggleRecording,
                child: Text(_isRecording ? 'Detener Grabación' : 'Grabar Audio'),
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



