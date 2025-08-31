import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Utilisateur {
  final int? id;
  final String nom;
  final String email;

  Utilisateur({this.id, required this.nom, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
    };
  }

  // Définissez la méthode fromMap pour créer un Utilisateur à partir d'un Map
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
    );
  }

  
}

class UtilisateurDatabase {
  late Database _database;
  Future<void> initialisation() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'utilisateurs.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE utilisateurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            email TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUtilisateur(Utilisateur utilisateur) async {
    await _database.insert(
      'utilisateurs',
      utilisateur.toMap(),
    );
  }

  Future<void> insertUtilisateur_(Utilisateur utilisateur) async {

    await _database.rawInsert(

      'INSERT INTO utilisateurs (nom, email) VALUES (?, ?)',

      [utilisateur.nom, utilisateur.email],

    );
  }

  Future<void> updateUtilisateur(Utilisateur utilisateur) async {

    await _database.update(

      'utilisateurs',

      utilisateur.toMap(),

      where: 'id = ?',

      whereArgs: [utilisateur.id],

    );

  }
  
  Future<void> updateUtilisateur_(Utilisateur utilisateur) async {

    await _database.rawUpdate(

      '''

      UPDATE utilisateurs

      SET nom = ?, email = ?

      WHERE id = ?

      ''',

      [utilisateur.nom, utilisateur.email, utilisateur.id],

    );
  }

  Future<void> deleteUtilisateur(int id) async {

    await _database.delete(

      'utilisateurs',

      where: 'id = ?',

      whereArgs: [id],

    );

  }

  Future<void> deleteUtilisateur_(int id) async {

    await await _database.rawDelete('DELETE FROM utilisateurs WHERE id = ?', [id]);

  }

  Future<List<Utilisateur>> getAllUtilisateurs() async {

    final List<Map<String, dynamic>> maps =

        await _database.query('utilisateurs');

    return List.generate(maps.length, (i) {

      return Utilisateur(

        id: maps[i]['id'],

        nom: maps[i]['nom'],

        email: maps[i]['email'],

      );

    });

  }
}
