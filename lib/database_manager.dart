import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'modele/Redacteur.dart';


class DatabaseManager {
  
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initialisation('redacteurs.db');
    return _database!;
  }

  Future<Database> initialisation(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await instance.database;
    final result = await db.query('redacteurs');
    return result.map((map) => Redacteur.fromMap(map)).toList();
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await instance.database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
