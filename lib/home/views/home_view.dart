import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_app/modules/auth/models/note_model.dart';
import '../../core/utils/theme_controller.dart';
import '../controllers/home_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

//==============================================================================
// HomeView: الواجهة الرسومية للشاشة الرئيسية
//==============================================================================
// [مهم للمناقشة]
// هذه الفئة (Class) هي المسؤولة عن عرض كل العناصر المرئية في الشاشة الرئيسية.
// هي تتبع نمط GetView<HomeController>، وهو ويدجت ذكي من GetX يقوم تلقائيًا
// بالبحث عن HomeController المسجل، مما يتيح لنا الوصول إليه مباشرة باستخدام controller.
// هذا يجعل الكود أنظف وأقصر.
//==============================================================================
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(): هذه الدالة تقوم بإنشاء وتسجيل الـ Controllers في ذاكرة GetX
    // لتكون متاحة للاستخدام في التطبيق.
    Get.put(HomeController());
    Get.put(ThemeController());

    return Scaffold(
      // --- 1. بناء شريط العنوان (AppBar) بشكل ديناميكي ---
      // [مهم للمناقشة]
      // نستخدم هنا Obx لمراقبة متغير isSearchMode في الـ Controller.
      // Obx يعيد بناء الويدجت الذي بداخله تلقائيًا عندما تتغير قيمة أي متغير .obs
      // مستخدم بداخله. هذا يسمح لنا بالتبديل بين شريط العنوان العادي وشريط البحث بسلاسة.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => _buildAppBar(context, controller)),
      ),

      // --- 2. بناء جسم الصفحة (Body) ---
      // نستخدم Obx مرة أخرى لمراقبة قائمة الملاحظات filteredNotes.
      // عندما يتم إضافة أو حذف أو فلترة ملاحظة، Obx يعيد بناء هذا الجزء تلقائيًا.
      body: Obx(() {
        // إذا كانت قائمة الملاحظات المعروضة فارغة...
        if (controller.filteredNotes.isEmpty) {
          return Center(
            // ...نعرض رسالة مختلفة بناءً على حالة البحث.
            child: Text(
              controller.searchQuery.value.isEmpty
                  ? 'No notes found.\nTap + to add one!' // حالة عدم وجود ملاحظات إطلاقًا
                  : 'No notes match your search.', // حالة عدم وجود نتائج للبحث
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          );
        }
        // إذا كانت هناك ملاحظات، نعرضها في قائمة متحركة.
        // [مهم للمناقشة]
        // نستخدم هنا حزمة flutter_staggered_animations لإضافة تأثيرات جمالية.
        // AnimationLimiter: هو الويدجت الأب الذي يحدد نطاق الأنيميشن.
        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.filteredNotes.length, // عدد العناصر هو طول القائمة المفلترة
            itemBuilder: (context, index) {
              final note = controller.filteredNotes[index];
              // AnimationConfiguration.staggeredList: يضبط الأنيميشن لكل عنصر في القائمة
              // مع تأخير بسيط بين كل عنصر والذي يليه (تأثير متدرج).
              return AnimationConfiguration.staggeredList(
                position: index, // موقع العنصر في القائمة
                duration: const Duration(milliseconds: 500), // مدة الأنيميشن
                // SlideAnimation: يعطي تأثير انزلاق للعنصر.
                child: SlideAnimation(
                  verticalOffset: 100.0, // المسافة التي ينزلق منها العنصر عموديًا
                  // FadeInAnimation: يعطي تأثير ظهور تدريجي للعنصر.
                  child: Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    // عند الضغط على البطاقة، نفتح حوار التعديل.
                    onTap: () {
                      _showAddOrUpdateDialog(context, controller, existingNote: note);
                    },
                    // عنوان الملاحظة.
                    title: Text(
                      note.title.isEmpty ? "Untitled" : note.title,
                      style: Theme.of(context).textTheme.titleLarge, // استخدام نمط الخط من الثيم مباشرة
                    ),
                    // محتوى الملاحظة وتاريخها.
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.content,
                            maxLines: 2, // عرض سطرين فقط من المحتوى
                            overflow: TextOverflow.ellipsis, // إضافة "..." إذا كان المحتوى أطول
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 12), // مسافة بين المحتوى والتاريخ
                          // [مهم للمناقشة]
                          // نستخدم حزمة intl لتنسيق التاريخ والوقت.
                          // DateTime.parse: تحول النص المخزن في قاعدة البيانات إلى كائن تاريخ.
                          // DateFormat.yMMMd().add_jm(): تقوم بتنسيق التاريخ ليظهر بشكل قابل للقراءة (e.g., Sep 21, 2025, 6:30 PM).
                          Text(
                            DateFormat.yMMMd().add_jm().format(DateTime.parse(note.createdAt)),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // أيقونة الحذف.
                    trailing: IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteConfirmation(context, controller, note.id!);
                      },
                    ),
                  ),
                ),
              ),
              );
            },
          ),
        );
      }),
      // زر الإضافة العائم.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrUpdateDialog(context, controller);
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  // --- دالة بناء شريط العنوان (AppBar Builder) ---
  // دالة خاصة (private) مسؤولة عن بناء شريط العنوان بناءً على حالة البحث.
  AppBar _buildAppBar(BuildContext context, HomeController controller) {
    // [مهم للمناقشة]
    // هذا هو التعديل الأخير الذي قمنا به لتحسين تجربة البحث.
    // 1. إنشاء متحكم نصي (TextEditingController).
    //    وظيفته: التحكم في النص الموجود داخل حقل البحث (TextField).
    //    هذا يسمح لنا بمسح النص برمجيًا عند الضغط على زر "X".
    final TextEditingController searchController = TextEditingController();

    // إذا كنا في وضع البحث...
    if (controller.isSearchMode.value) {
      return AppBar(
        leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: controller.toggleSearchMode, // الخروج من وضع البحث
        ),
        // ...نعرض حقل نصي للبحث.
        title: TextField(
          // 2. ربط المتحكم النصي بحقل البحث.
          controller: searchController,
          autofocus: true, // التركيز على الحقل تلقائيًا عند ظهوره
          onChanged: controller.updateSearchQuery, // استدعاء دالة التحديث في الـ Controller مع كل تغيير
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none, // بدون حدود لإعطاء مظهر نظيف
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.close_square),
            // 3. تعديل وظيفة زر المسح "X".
            //    عند الضغط عليه، نقوم الآن بعملين:
            onPressed: () {
              searchController.clear(); // أ. مسح النص من حقل البحث في الواجهة.
              controller.updateSearchQuery(''); // ب. تحديث حالة البحث في الـ Controller.
            },
          ),
        ],
      );
    } else {
      // إذا لم نكن في وضع البحث، نعرض شريط العنوان العادي.
      return AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal_1),
            onPressed: controller.toggleSearchMode, // الدخول إلى وضع البحث
          ),
          IconButton(
            icon: Icon(Get.isDarkMode ? Iconsax.sun_1 : Iconsax.moon),
            onPressed: () => Get.find<ThemeController>().switchTheme(), // تبديل المظهر
          ),
        ],
      );
    }
  }

  // --- دالة حوار الإضافة والتعديل ---
  // دالة خاصة مسؤولة عن إظهار مربع الحوار لإضافة أو تعديل ملاحظة.
  void _showAddOrUpdateDialog(BuildContext context, HomeController controller, {Note? existingNote}) {
    final isUpdating = existingNote != null; // تحديد إذا كانت العملية تعديل أم إضافة
    final titleController = TextEditingController(text: existingNote?.title ?? '');
    final contentController = TextEditingController(text: existingNote?.content ?? '');
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
    );

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor, // استخدام اللون من الثيم
        shape: Theme.of(context).dialogTheme.shape, // استخدام الشكل من الثيم
        title: Text(
          isUpdating ? "Update Note" : "Add New Note",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView( // للسماح بالتمرير إذا ظهرت لوحة المفاتيح
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            TextField(
            controller: titleController,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: contentController,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            maxLines: 5,
            decoration: InputDecoration(
            hintText: "Content",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 2,
              ),
            ),
          ),
        ),
        ],
      ),
    ),
    actions: [
    TextButton(
    onPressed: () => Get.back(),
    child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
    ),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    onPressed: () {
    // التحقق من أن الحقول ليست فارغة قبل الحفظ.
    if (contentController.text.isEmpty && titleController.text.isEmpty) {
    Get.snackbar(
    "Empty Note",
    "Please enter a title or content for your note.",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
    margin: const EdgeInsets.all(10),
    );
    } else {
    // استدعاء الدالة المناسبة في الـ Controller.
    if (isUpdating) {
    controller.updateNote(existingNote.id!, titleController.text, contentController.text);
    } else {
    controller.addNote(titleController.text, contentController.text);
    }
    Get.back(); // إغلاق الحوار بعد الحفظ.
    }
    },
    child: Text(isUpdating ? "Update" : "Add"),
    ),
    ],
    ),
    );
  }

  // --- دالة حوار تأكيد الحذف ---
  void _showDeleteConfirmation(BuildContext context, HomeController controller, int noteId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        shape: Theme.of(context).dialogTheme.shape,
        title: Text("Delete Note", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Text("Are you sure you want to delete this note?", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.onSurface))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              controller.deleteNote(noteId);
              Get.back();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}