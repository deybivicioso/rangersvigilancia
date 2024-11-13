import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Inicialización del databaseFactory para FFI
  Future<Database> get database async {
    if (_database != null) return _database!;
    databaseFactory = databaseFactoryFfi; // Asegúrate de usar la fábrica FFI
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rangesvigilancia.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vigilancia (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        fecha TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        foto BLOB,
        audio BLOB
      )
    ''');
  }

  // Método para insertar un registro en la tabla 'vigilancia'
  Future<int> insertVigilancia(Map<String, dynamic> vigilancia) async {
    Database db = await database;
    return await db.insert('vigilancia', vigilancia);
  }

  // Método para obtener todos los registros de la tabla 'vigilancia'
  Future<List<Map<String, dynamic>>> getVigilancia() async {
    Database db = await database;
    return await db.query('vigilancia');
  }

  // Método para eliminar un registro por ID
  Future<int> deleteVigilancia(int id) async {
    Database db = await database;
    return await db.delete('vigilancia', where: 'id = ?', whereArgs: [id]);
  }

  // Método para actualizar un registro por ID
  Future<int> updateVigilancia(int id, Map<String, dynamic> vigilancia) async {
    Database db = await database;
    return await db.update(
      'vigilancia',
      vigilancia,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
