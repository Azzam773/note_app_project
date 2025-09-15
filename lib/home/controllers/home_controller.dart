import 'package:get/get.dart';
import '../../data/providers/database_provider.dart';
import '../../modules/auth/models/note_model.dart'; // هذا المسار قد يحتاج تعديل

class HomeController extends GetxController {
  final dbProvider = DatabaseProvider();
  var notes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNotes();
  }

  void fetchAllNotes() async {
    notes.value = await dbProvider.getAllNotes();
  }

  void addNote(String title, String content) async {
    if (title.isEmpty && content.isEmpty) {
      Get.snackbar("Error", "Cannot add an empty note.");
      return;
    }
    final newNote = Note(title: title, content: content);
    await dbProvider.createNote(newNote);
    fetchAllNotes();
    Get.back();
  }

  void deleteNote(int id) async {
    await dbProvider.deleteNote(id);
    fetchAllNotes();
  }

  // دالة لتعديل ملاحظة موجودة
  void updateNote(int id, String title, String content) async {
    final updatedNote = Note(id: id, title: title, content: content);
    await dbProvider.updateNote(updatedNote);
    // إعادة جلب كل الملاحظات لتحديث الواجهة
    fetchAllNotes();
    Get.back(); // لإغلاق نافذة التعديل
  }
}