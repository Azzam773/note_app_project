import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/modules/auth/models/note_model.dart'; // <-- تأكد من أن هذا المسار صحيح
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // GetView هي ويدجت خاصة بـ GetX تجد الـ Controller تلقائياً
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // يجب أن نضع الـ controller في الذاكرة أولاً
    // Get.put() يقوم بإنشاء وتسجيل الـ HomeController
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Obx هي ويدجت خاصة بـ GetX تعيد بناء نفسها تلقائياً
        // عندما تتغير قيمة المتغيرات التي بداخلها (مثل قائمة notes)
        if (controller.notes.isEmpty) {
          return const Center(
            child: Text(
              'No notes found.\nTap a to add one!',
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            final note = controller.notes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                // --- التعديل الأول: إضافة onTap لفتح نافذة التعديل ---
                onTap: () {
                  _showAddOrUpdateDialog(existingNote: note);
                },
                title: Text(note.title.isEmpty ? "No Title" : note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    // إظهار نافذة تأكيد قبل الحذف
                    Get.defaultDialog(
                      title: "Delete Note",
                      middleText: "Are you sure you want to delete this note?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        controller.deleteNote(note.id!);
                        Get.back(); // لإغلاق نافذة التأكيد
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- التعديل الثاني: استدعاء الدالة الجديدة عند الإضافة ---
          // إظهار نافذة لإضافة ملاحظة جديدة
          _showAddOrUpdateDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- التعديل الثالث: استبدال الدالة القديمة بدالة جديدة تدعم الإضافة والتعديل ---
  // دالة خاصة لإظهار نافذة إضافة أو تعديل الملاحظة
  void _showAddOrUpdateDialog({Note? existingNote}) {
    final isUpdating = existingNote != null;

    final TextEditingController titleController =
    TextEditingController(text: existingNote?.title ?? '');
    final TextEditingController contentController =
    TextEditingController(text: existingNote?.content ?? '');

    Get.defaultDialog(
      title: isUpdating ? "Update Note" : "Add New Note",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              hintText: "Enter note title",
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: "Content",
              hintText: "Enter note content",
            ),
            maxLines: 3,
          ),
        ],
      ),
      textConfirm: isUpdating ? "Update" : "Add",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (isUpdating) {
          // استدعاء دالة updateNote من الـ HomeController
          controller.updateNote(
            existingNote.id!,
            titleController.text,
            contentController.text,
          );
        } else {
          // استدعاء دالة addNote من الـ HomeController
          controller.addNote(
            titleController.text,
            contentController.text,
          );
        }
      },
    );
  }
}