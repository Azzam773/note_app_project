import 'package:get/get.dart';
import '../../data/providers/database_provider.dart';
import '../../modules/auth/models/note_model.dart';

//==============================================================================
// HomeController: العقل المدبر للشاشة الرئيسية
//==============================================================================
// هذا الـ Controller هو المسؤول عن كل العمليات المنطقية في الشاشة الرئيسية،
// مثل جلب الملاحظات من قاعدة البيانات، إضافتها، حذفها، تعديلها، والأهم: فلترتها عند البحث.
class HomeController extends GetxController {
  //----------------------------------------------------------------------------
  // 1. المتغيرات الأساسية (State Variables)
  //----------------------------------------------------------------------------

  /// @doc: اتصال بقاعدة البيانات.
  final dbProvider = DatabaseProvider();

  /// @doc: [مهم جدًا للمناقشة] هذه القائمة هي "المخزن الرئيسي" الذي يحتوي على كل الملاحظات
  /// التي تم جلبها من قاعدة البيانات. نحن لا نعرض هذه القائمة مباشرة في الواجهة،
  /// بل نستخدمها كمصدر للبيانات الخام للفلترة.
  final RxList<Note> _allNotes = <Note>[].obs;

  /// @doc: [مهم جدًا للمناقشة] هذه هي القائمة التي يتم عرضها فعليًا في الواجهة.
  /// محتواها يتغير باستمرار:
  /// - إذا كان البحث فارغًا، فإنها تحتوي على كل الملاحظات (نسخة من _allNotes).
  /// - إذا كان المستخدم يبحث، فإنها تحتوي فقط على الملاحظات التي تطابق البحث.
  final RxList<Note> filteredNotes = <Note>[].obs;

  /// @doc: متغير لتخزين نص البحث الذي يكتبه المستخدم.
  /// استخدام .obs يجعله تفاعليًا، بحيث يمكن لـ GetX مراقبة أي تغيير يطرأ عليه.
  final RxString searchQuery = ''.obs;

  /// @doc: متغير لتحديد ما إذا كان وضع البحث فعالاً أم لا.
  /// هذا يساعدنا في الواجهة على معرفة هل نعرض عنوان الصفحة أم حقل البحث.
  final RxBool isSearchMode = false.obs;

  //----------------------------------------------------------------------------
  // 2. دورة حياة الـ Controller (Lifecycle)
  //----------------------------------------------------------------------------

  /// @doc: هذه الدالة يتم استدعاؤها تلقائيًا بواسطة GetX مرة واحدة فقط
  /// عندما يتم إنشاء الـ Controller.
  @override
  void onInit() {
    super.onInit();
    // نبدأ بجلب كل الملاحظات من قاعدة البيانات.
    fetchAllNotes();

    // [مهم جدًا للمناقشة] هنا نستخدم دالة "debounce" الذكية من GetX.
    // وظيفتها: مراقبة متغير searchQuery. عندما يتغير (أي عندما يكتب المستخدم)،
    // فإنها لا تنفذ دالة الفلترة _filterNotes فورًا، بل تنتظر لمدة 300 جزء من الثانية
    // بعد أن يتوقف المستخدم عن الكتابة.
    // الفائدة: هذا يحسن أداء التطبيق بشكل كبير ويمنع تنفيذ عملية الفلترة بشكل متكرر
    // ومجهد مع كل ضغطة زر، مما يجعل تجربة البحث سلسة وخفيفة.
    debounce(searchQuery, (_) => _filterNotes(), time: const Duration(milliseconds: 300));
  }

  //----------------------------------------------------------------------------
  // 3. دوال البحث والفلترة (Search and Filter Logic)
  //----------------------------------------------------------------------------

  /// @doc: دالة خاصة (private) لتنفيذ عملية الفلترة.
  void _filterNotes() {
    // نحصل على نص البحث ونحوله إلى حروف صغيرة لتكون المقارنة غير حساسة لحالة الأحرف.
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      // إذا كان حقل البحث فارغًا، نعرض كل الملاحظات.
      // assignAll هي طريقة فعالة لتحديث قائمة GetX.
      filteredNotes.assignAll(_allNotes);
    } else {
      // إذا كان هناك نص في حقل البحث...
      filteredNotes.assignAll(
        // نستخدم دالة where لفلترة "المخزن الرئيسي" (_allNotes).
        _allNotes.where((note) {
          // نحول عنوان ومحتوى كل ملاحظة إلى حروف صغيرة أيضًا.
          final titleLower = note.title.toLowerCase();
          final contentLower = note.content.toLowerCase();

          // نتحقق إذا كان العنوان "يحتوي" على نص البحث، أو إذا كان المحتوى "يحتوي" على نص البحث.
          return titleLower.contains(query) || contentLower.contains(query);
        }).toList(), // نحول النتيجة إلى قائمة.
      );
    }
  }

  /// @doc: دالة عامة يتم استدعاؤها من الواجهة لتحديث نص البحث.
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// @doc: دالة لتبديل وضع البحث (من عرض العنوان إلى عرض حقل البحث والعكس).
  void toggleSearchMode() {
    isSearchMode.value = !isSearchMode.value;
    // إذا خرجنا من وضع البحث، يجب أن نتأكد من أن نص البحث فارغ.
    if (!isSearchMode.value) {
      updateSearchQuery('');
    }
  }

  //----------------------------------------------------------------------------
  // 4. دوال التعامل مع قاعدة البيانات (CRUD Operations)
  //----------------------------------------------------------------------------

  /// @doc: جلب كل الملاحظات من قاعدة البيانات وتحديث القوائم.
  void fetchAllNotes() async {
    _allNotes.value = await dbProvider.getAllNotes();
    // بعد جلب البيانات، نقوم بتشغيل الفلترة فورًا.
    // هذا يضمن أن filteredNotes تحتوي على البيانات الصحيحة عند بدء التشغيل.
    _filterNotes();
  }

  /// @doc: إضافة ملاحظة جديدة.
  void addNote(String title, String content) async {
    final newNote = Note(title: title, content: content, createdAt: DateTime.now().toIso8601String());
    await dbProvider.createNote(newNote);
    // بعد الإضافة، نعيد جلب كل شيء من قاعدة البيانات لضمان أن البيانات متزامنة.
    fetchAllNotes();
  }

  /// @doc: حذف ملاحظة بناءً على الـ id.
  void deleteNote(int id) async {
    await dbProvider.deleteNote(id);
    // بعد الحذف، نعيد جلب كل شيء.
    fetchAllNotes();
  }

  /// @doc: تعديل ملاحظة موجودة.
  void updateNote(int id, String title, String content) async {
    // نبحث عن الملاحظة الأصلية للحفاظ على تاريخ إنشائها الأصلي.
    final originalNote = _allNotes.firstWhere(
          (note) => note.id == id,
      // في حالة عدم العثور عليها (وهو أمر غير محتمل)، ننشئ كائنًا افتراضيًا لتجنب الأخطاء.
      orElse: () => Note(id: id, title: '', content: '', createdAt: DateTime.now().toIso8601String()),
    );

    // ننشئ الكائن المحدث مع البيانات الجديدة وتاريخ الإنشاء القديم.
    final updatedNote = Note(
      id: id,
      title: title,
      content: content,
      createdAt: originalNote.createdAt,
    );

    await dbProvider.updateNote(updatedNote);
    // بعد التعديل، نعيد جلب كل شيء.
    fetchAllNotes();
  }
}