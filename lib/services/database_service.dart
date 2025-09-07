import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/Note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL,
            isPinned INTEGER NOT NULL DEFAULT 0
          );
        ''');
        await db.execute('CREATE INDEX idx_notes_updatedAt ON notes(updatedAt DESC);');
        await db.execute('CREATE INDEX idx_notes_isPinned ON notes(isPinned DESC);');
      },
    );
  }

  Future<List<Note>> getNotes({String query = ''}) async {
    final database = await db;
    final where = query.isNotEmpty ? 'WHERE title LIKE ? OR content LIKE ?' : '';
    final args = query.isNotEmpty ? ['%$query%', '%$query%'] : null;
    final maps = await database.rawQuery('''
      SELECT * FROM notes
      $where
      ORDER BY isPinned DESC, updatedAt DESC
    ''', args);
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<Note> insert(Note note) async {
    final database = await db;
    final id = await database.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<int> update(Note note) async {
    final database = await db;
    return database.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final database = await db;
    return database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
