import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// هنا نقوم باستيراد ملف المودل الذي أنشأناه في الخطوة السابقة
import '../../modules/auth/models/note_model.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'notes_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL)",
        );
      },
    );
  }

  // دالة لإضافة ملاحظة جديدة
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  // U - Update: تعديل ملاحظة موجودة
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // دالة لجلب كل الملاحظات
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // دالة لحذف ملاحظة
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}