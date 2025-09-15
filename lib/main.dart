import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/home/views/home_view.dart';
import 'core/utils/app_themes.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
        (options) {
             // رابط موقع ال sentry
      options.dsn = 'https://fab09c0edd53de24917c4ffd995b43b3@o4510020777541632.ingest.us.sentry.io/4510020787372032';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp هي النسخة المحسنة من MaterialApp من مكتبة GetX
    return GetMaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false, // لإخفاء شريط "Debug"

      // --- هنا نستخدم الثيمات التي أنشأناها ---
      theme: AppThemes.lightTheme, // الثيم الفاتح هو الافتراضي
      darkTheme: AppThemes.darkTheme, // الثيم الداكن
      themeMode: ThemeMode.system, // اجعل التطبيق يتبع ثيم النظام (فاتح/داكن)

      // --- هنا نحدد الشاشة الأولى التي ستظهر ---
      home: const HomeView(),
    );
  }
}