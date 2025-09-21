import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/utils/app_themes.dart';
import 'core/utils/theme_controller.dart';
import 'home/views/home_view.dart';

//==============================================================================
// main: نقطة انطلاق التطبيق
//==============================================================================
// دالة main هي أول دالة يتم تنفيذها عند تشغيل التطبيق.
// هي مسؤولة عن عمليات "التهيئة" (Initialization) الأساسية قبل عرض أي واجهة للمستخدم.
// جعلناها async لأن عمليات التهيئة (مثل Sentry و GetStorage) هي عمليات غير متزامنة (asynchronous).
//==============================================================================
Future<void> main() async {
  // [مهم للمناقشة]
  // نستخدم هنا SentryFlutter.init لتهيئة خدمة Sentry لمراقبة الأخطاء.
  // Sentry تقوم بالتقاط أي أخطاء أو انهيارات تحدث في التطبيق وإرسال تقارير مفصلة عنها
  // لمساعدتنا في إصلاحها.
  //
  // appRunner هي دالة خاصة بـ Sentry تضمن أن التطبيق لن يعمل إلا بعد
  // أن يتم تهيئة Sentry بنجاح. هذا يضمن أننا سنلتقط حتى الأخطاء التي تحدث عند بدء التشغيل.
  await SentryFlutter.init(
        (options) {
      // dsn هو المفتاح الفريد الذي يربط تطبيقنا بمشروعنا على موقع Sentry.
      options.dsn = 'https://fab09c0edd53de24917c4ffd995b43b3@o4510020777541632.ingest.us.sentry.io/4510020787372032';
      // tracesSampleRate يحدد نسبة تتبع الأداء التي سيتم إرسالها. 1.0 يعني 100%.
      options.tracesSampleRate = 1.0;
    },
    // appRunner سيقوم بتشغيل الكود الذي بداخله بعد تهيئة Sentry.
    appRunner: () async {
      // --- هنا نقوم بكل عمليات التهيئة الأساسية للتطبيق ---

      // 1. WidgetsFlutterBinding.ensureInitialized():
      //    هذه الدالة ضرورية جدًا عند وجود عمليات await قبل runApp.
      //    هي تضمن أن "محرك" فلاتر جاهز للتواصل مع نظام التشغيل قبل تنفيذ أي كود يعتمد عليه.
      WidgetsFlutterBinding.ensureInitialized();

      // 2. GetStorage.init():
      //    تهيئة حزمة get_storage لتكون جاهزة لعمليات القراءة والكتابة.
      //    يجب استدعاؤها مرة واحدة فقط قبل استخدام GetStorage.
      await GetStorage.init();

      // 3. Get.put(ThemeController()):
      //    تسجيل ThemeController في ذاكرة GetX ليكون متاحًا للاستخدام
      //    في MyApp والويدجتس الأخرى.
      Get.put(ThemeController());

      // 4. runApp(const MyApp()):
      //    الدالة الرئيسية في فلاتر التي تقوم برسم الويدجت الجذر (MyApp) على الشاشة
      //    وبدء تشغيل التطبيق فعليًا.
      runApp(const MyApp());
    },
  );
}

//==============================================================================
// MyApp: الويدجت الجذر (Root Widget) للتطبيق
//==============================================================================
// هذه هي الويدجت الأساسية التي تحتوي على كل التطبيق.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [مهم للمناقشة]
    // Get.find(): نستخدم هذه الدالة للبحث عن نسخة ThemeController
    // التي قمنا بتسجيلها مسبقًا في دالة main.
    final ThemeController themeController = Get.find();

    // GetMaterialApp هي نسخة محسنة من MaterialApp مقدمة من حزمة GetX.
    // هي توفر ميزات إضافية مثل إدارة الـ routes والـ themes بسهولة.
    return GetMaterialApp(
      title: 'Note', // اسم التطبيق الذي يظهر في مدير المهام في الهاتف.
      debugShowCheckedModeBanner: false, // لإخفاء شريط "Debug" المزعج في الزاوية العلوية.

      // --- تطبيق نظام الثيمات ---
      // نمرر الثيمات التي قمنا بتعريفها في AppTheme.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // [مهم للمناقشة]
      // themeMode هو الذي يحدد أي ثيم سيتم عرضه (فاتح، داكن، أو حسب النظام).
// هنا، نربطه مباشرة بالـ getter الموجود في ThemeController.
      // themeController.theme سيقوم بقراءة القيمة من ذاكرة الهاتف وتحديد المظهر المناسب.
      // هذا هو سر "تذكر" التطبيق للمظهر الذي اختاره المستخدم حتى بعد إغلاقه.
      themeMode: themeController.theme,

      // home يحدد أول شاشة ستظهر عند فتح التطبيق.
      home: const HomeView(),
    );
  }
}