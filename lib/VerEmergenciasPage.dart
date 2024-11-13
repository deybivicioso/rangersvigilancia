import 'package:flutter/material.dart';
import 'package:rangersvigilancia/databasehelper.dart';
//import 'DatabaseHelper.dart';

class VerEmergenciasPage extends StatefulWidget {
  @override
  _VerEmergenciasPageState createState() => _VerEmergenciasPageState();
}

class _VerEmergenciasPageState extends State<VerEmergenciasPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _vigilancia;

  @override
  void initState() {
    super.initState();
    // Cargar los registros de vigilancia al inicializar la página
    _vigilancia = _databaseHelper.getVigilancia();
  }

  // Método para eliminar un registro
  void _eliminarRegistro(int id) async {
    await _databaseHelper.deleteVigilancia(id);
    setState(() {
      _vigilancia = _databaseHelper.getVigilancia();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro eliminado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Datos de Vigilancia'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vigilancia,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos de vigilancia registrados'));
          }

          List<Map<String, dynamic>> datosVigilancia = snapshot.data!;

          return ListView.builder(
            itemCount: datosVigilancia.length,
            itemBuilder: (context, index) {
              var registro = datosVigilancia[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                child: ListTile(
                  title: Text('Título: ${registro['titulo']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${registro['fecha']}'),
                      Text('Descripción: ${registro['descripcion']}'),
                      SizedBox(height: 10),
                      registro['foto'] != null
                          ? Image.memory(
                              registro['foto'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Text('Sin imagen'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarRegistro(registro['id']),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
