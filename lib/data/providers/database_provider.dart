import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../modules/auth/models/note_model.dart';

//==============================================================================
// DatabaseProvider: المسؤول عن كل عمليات قاعدة البيانات
//==============================================================================
// [مهم للمناقشة]
// هذه الفئة تتبع نمط تصميم يسمى "Singleton Pattern".
//
// ما هو Singleton؟
// هو نمط يضمن وجود نسخة (instance) واحدة فقط من هذه الفئة على مستوى التطبيق كله.
//
// لماذا نستخدمه هنا؟
// لأن التعامل مع قاعدة البيانات يجب أن يتم من خلال نقطة وصول واحدة وموحدة
// لتجنب تضارب البيانات أو فتح اتصالات متعددة مع قاعدة البيانات في نفس الوقت،
// مما قد يسبب أخطاء ويستهلك موارد الجهاز.
//==============================================================================
class DatabaseProvider {
  // --- 1. تطبيق نمط Singleton ---

  // _instance هي النسخة الوحيدة والخاصة (private) من هذه الفئة.
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  // factory constructor هو نوع خاص من الـ constructors.
  // عندما يتم استدعاء DatabaseProvider() في أي مكان في الكود،
  // هذا الـ factory لا يقوم بإنشاء نسخة جديدة، بل يعيد دائمًا نفس النسخة _instance.
  factory DatabaseProvider() => _instance;

  // _internal هو constructor خاص (private)، مما يمنع أي شخص خارج هذه الفئة
  // من إنشاء نسخة جديدة باستخدام DatabaseProvider._internal().
  DatabaseProvider._internal();

  // --- 2. إعداد وتهيئة قاعدة البيانات ---

  // _database هو متغير سيحتفظ بالاتصال المفتوح مع قاعدة البيانات.
  // جعله static يضمن أنه مشترك على مستوى كل التطبيق (جزء من نمط Singleton).
  static Database? _database;

  // getter للوصول إلى قاعدة البيانات.
  Future<Database> get database async {
    // إذا كانت قاعدة البيانات قد تم تهيئتها بالفعل، قم بإعادتها مباشرة.
    if (_database != null) return _database!;
    // إذا لم تكن مهيأة، قم بتهيئتها أولاً ثم أعدها.
    _database = await _initDb();
    return _database!;
  }

  // دالة خاصة (private) لتهيئة قاعدة البيانات لأول مرة.
  Future<Database> _initDb() async {
    // getDatabasesPath(): دالة من sqflite تعطي المسار المناسب لحفظ ملفات قواعد البيانات في نظام التشغيل (Android/iOS).
    // join(): دالة من حزمة path تقوم بدمج المسار مع اسم ملف قاعدة البيانات بشكل صحيح.
    String path = join(await getDatabasesPath(), 'notes_app.db');

    // openDatabase تقوم بفتح الاتصال مع قاعدة البيانات. إذا لم يكن الملف موجودًا، تقوم بإنشائه.
    return await openDatabase(
      path,
      version: 1, // رقم إصدار قاعدة البيانات (مهم لعمليات الترقية المستقبلية).
      // onCreate هي دالة يتم استدعاؤها مرة واحدة فقط عندما يتم إنشاء ملف قاعدة البيانات لأول مرة.
      onCreate: (db, version) async {
        // هنا نكتب استعلام SQL لإنشاء جدول الملاحظات.
        await db.execute(
          // [مهم للمناقشة]
          // CREATE TABLE notes: أنشئ جدولاً اسمه notes.
          // id INTEGER PRIMARY KEY AUTOINCREMENT: حقل للرقم التعريفي، وهو مفتاح أساسي ويزداد تلقائيًا.
          // title TEXT NOT NULL: حقل لعنوان الملاحظة، من نوع نص، ولا يمكن أن يكون فارغًا.
          // content TEXT NOT NULL: حقل لمحتوى الملاحظة.
          // createdAt TEXT NOT NULL: حقل لتاريخ إنشاء الملاحظة.
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL, createdAt TEXT NOT NULL)",
        );
      },
    );
  }

  // --- 3. عمليات CRUD (Create, Read, Update, Delete) ---
  // [مهم للمناقشة]
  // هذه هي العمليات الأربعة الأساسية لأي قاعدة بيانات.

  // C - Create: دالة لإضافة ملاحظة جديدة
  Future<int> createNote(Note note) async {
    final db = await database; // احصل على اتصال بقاعدة البيانات.
    // db.insert تقوم بإدراج بيانات جديدة في الجدول.
    // 'notes': اسم الجدول.
    // note.toMap(): تقوم بتحويل كائن Note إلى Map لتكون متوافقة مع sqflite.
    // conflictAlgorithm.replace: إذا حاولت إدراج ملاحظة بنفس الـ id، قم باستبدالها.
    return await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
// U - Update: دالة لتعديل ملاحظة موجودة
  Future<int> updateNote(Note note) async {
    final db = await database;
    // db.update تقوم بتحديث بيانات موجودة.
    // 'notes': اسم الجدول.
    // note.toMap(): البيانات الجديدة.
    // where: 'id = ?': الشرط لتحديد الصف الذي سيتم تحديثه. علامة ? هي placeholder.
    // whereArgs: [note.id]: القيمة التي ستحل محل علامة ?. هذا الأسلوب يمنع هجمات SQL Injection.
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // R - Read: دالة لجلب كل الملاحظات
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    // db.query تقوم بجلب البيانات من الجدول.
    // 'notes': اسم الجدول.
    // orderBy: 'id DESC': ترتيب النتائج تنازليًا حسب الـ id، بحيث تظهر أحدث الملاحظات أولاً.
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');

    // maps الآن تحتوي على قائمة من Map، كل Map يمثل صفًا في الجدول.
    // نحتاج لتحويل هذه القائمة إلى قائمة من كائنات Note.
    return List.generate(maps.length, (i) {
      // Note.fromMap تقوم بتحويل Map إلى كائن Note.
      return Note.fromMap(maps[i]);
    });
  }

  // D - Delete: دالة لحذف ملاحظة
  Future<int> deleteNote(int id) async {
    final db = await database;
    // db.delete تقوم بحذف صف من الجدول.
    // 'notes': اسم الجدول.
    // where: 'id = ?': الشرط لتحديد الصف الذي سيتم حذفه.
    // whereArgs: [id]: القيمة التي ستحل محل علامة ?.
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}