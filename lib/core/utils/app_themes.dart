import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/core/utils/app_colors.dart';

//==============================================================================
// AppTheme: مركز التحكم في مظهر التطبيق
//==============================================================================
// [مهم للمناقشة]
// هذه الفئة (Class) هي المسؤولة عن تجميع كل عناصر التصميم (الألوان، الخطوط، أشكال الأزرار، إلخ)
// في كائن واحد يسمى ThemeData. هذا الكائن يتم تمريره إلى GetMaterialApp في ملف main.dart
// ليتم تطبيقه على مستوى التطبيق بالكامل.
class AppTheme {
  // AppTheme._() هو constructor خاص. وظيفته منع أي شخص من إنشاء نسخة (instance)
  // من هذه الفئة، لأننا نريد استخدامها بشكل ثابت (static) فقط.
  AppTheme._();

  // --- تعريف مزيج الخطوط ---
  // [مهم للمناقشة]
  // هنا نستخدم حزمة google_fonts لتحميل وتطبيق الخطوط مباشرة من الإنترنت.
  // لقد قمنا بتعريف نوعين من الخطوط لتحقيق هوية بصرية مميزة:
  // 1. Lato: خط بسيط وواضح وعملي، مناسب للنصوص الطويلة ومحتوى الملاحظات.
  // 2. Playfair Display: خط أنيق وفاخر (Serif)، مناسب للعناوين الرئيسية لجذب الانتباه.

  // 1. تعريف خط النصوص الأساسية (Body)
  // GoogleFonts.latoTextTheme تأخذ ثيم نصوص موجود وتطبق عليه خط Lato.
  static final _lightBodyTextTheme = GoogleFonts.latoTextTheme(ThemeData.light().textTheme);
  static final _darkBodyTextTheme = GoogleFonts.latoTextTheme(ThemeData.dark().textTheme);

  // 2. تعريف خط العناوين (Headings)
  static final _lightHeadlineTextTheme = GoogleFonts.playfairDisplayTextTheme(ThemeData.light().textTheme);
  static final _darkHeadlineTextTheme = GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme);


  // =================================================================
  // Light Theme - المظهر الفاتح
  // =================================================================
  // ThemeData هو الكائن الذي يحتوي على كل معلومات التصميم.
  static final ThemeData lightTheme = ThemeData(
    // brightness يخبر فلاتر أن هذا الثيم فاتح، مما يؤثر على ألوان العناصر الافتراضية (مثل لون شريط الحالة).
    brightness: Brightness.light,
    // primaryColor هو لون قديم، لكن من الجيد تعريفه للتوافقية.
    primaryColor: LightColors.primary,
    // scaffoldBackgroundColor يحدد لون الخلفية الرئيسي للتطبيق.
    scaffoldBackgroundColor: LightColors.secondary,

    // colorScheme هو النظام الأحدث والأكثر أهمية لتعريف الألوان في Material Design 3.
    colorScheme: const ColorScheme.light(
      primary: LightColors.primary, // لون الأسطح الرئيسية (مثل البطاقات)
      onPrimary: LightColors.onPrimary, // لون النص على الأسطح الرئيسية
      secondary: LightColors.secondary, // لون الخلفية العام
      onSecondary: LightColors.onPrimary, // لون النص على الخلفية العامة
      surface: LightColors.primary, // مرادف لـ primary في هذا التصميم
      onSurface: LightColors.onPrimary, // مرادف لـ onPrimary
      surfaceBright: LightColors.secondary, // (غير مستخدم بشكل كبير في هذا التصميم)
      onSurfaceVariant: LightColors.onPrimary, // (غير مستخدم بشكل كبير في هذا التصميم)
      error: LightColors.error, // لون الخطأ
      onError: LightColors.onError, // لون النص على الخطأ
      primaryContainer: LightColors.accent, // اللون المميز (للأزرار والعناصر التفاعلية)
      onPrimaryContainer: LightColors.onAccent, // لون النص على اللون المميز
    ),

    // appBarTheme لتخصيص شريط العنوان العلوي بشكل موحد في كل التطبيق.
    appBarTheme: AppBarTheme(
      backgroundColor: LightColors.secondary, // نفس لون خلفية التطبيق
      elevation: 0, // بدون ظل لإعطاء مظهر مسطح (flat) وحديث
      iconTheme: const IconThemeData(color: LightColors.onPrimary), // لون أيقونات شريط العنوان
      // --- استخدام خط العناوين هنا ---
      // نأخذ نمط titleLarge من ثيم خط العناوين ونقوم بتخصيصه أكثر.
      titleTextStyle: _lightHeadlineTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
    ),

// cardTheme لتخصيص كل البطاقات (Cards) في التطبيق.
    cardTheme: CardThemeData(
    color: LightColors.primary,
    elevation: 1, // ظل خفيف جدًا لإعطاء عمق بسيط
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // حواف دائرية
    ),
  ),

  // floatingActionButtonTheme لتخصيص الزر العائم (زر الإضافة).
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
  backgroundColor: LightColors.accent, // اللون الذهبي المميز
  foregroundColor: LightColors.onAccent, // لون الأيقونة (زائد)
  ),

  // --- استخدام خط النصوص الأساسية هنا مع دمج خط العناوين ---
  // [مهم للمناقشة]
  // textTheme هو المسؤول عن تحديد شكل كل أنواع النصوص في التطبيق.
  // هنا، نأخذ ثيم خط Lato كأساس، ثم نقوم باستبدال أنماط العناوين فقط
  // بأنماط من ثيم خط Playfair Display. هذا يعطينا أفضل ما في العالمين:
  // وضوح Lato للمحتوى، وجمال Playfair Display للعناوين.
  textTheme: _lightBodyTextTheme.copyWith(
  displayLarge: _lightHeadlineTextTheme.displayLarge,
  displayMedium: _lightHeadlineTextTheme.displayMedium,
  displaySmall: _lightHeadlineTextTheme.displaySmall,
  headlineLarge: _lightHeadlineTextTheme.headlineLarge,
  headlineMedium: _lightHeadlineTextTheme.headlineMedium,
  headlineSmall: _lightHeadlineTextTheme.headlineSmall,
  // نقوم بتخصيص titleLarge مرة أخرى هنا لضمان أن عناوين البطاقات تكون بخط سميك.
  titleLarge: _lightHeadlineTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
  ),

  // dialogBackgroundColor يحدد لون خلفية مربعات الحوار (Dialogs).
  dialogBackgroundColor: LightColors.secondary,
  // iconTheme يحدد اللون الافتراضي لكل الأيقونات في التطبيق.
  iconTheme: const IconThemeData(color: LightColors.onPrimary),
  );

  // =================================================================
  // Dark Theme - المظهر الداكن
  // =================================================================
  // نفس المبدأ المطبق في الثيم الفاتح، ولكن باستخدام ألوان من DarkColors.
  static final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: DarkColors.primary,
  scaffoldBackgroundColor: DarkColors.secondary,
  colorScheme: const ColorScheme.dark(
  primary: DarkColors.primary,
  onPrimary: DarkColors.onPrimary,
  secondary: DarkColors.secondary,
  onSecondary: DarkColors.onSecondary,
  surface: DarkColors.primary,
  onSurface: DarkColors.onPrimary,
  background: DarkColors.secondary,
  onBackground: DarkColors.onPrimary,
  error: DarkColors.error,
  onError: DarkColors.onError,
  primaryContainer: DarkColors.accent,
  onPrimaryContainer: DarkColors.onAccent,
  ),
  appBarTheme: AppBarTheme(
  backgroundColor: DarkColors.secondary,
  elevation: 0,
  iconTheme: const IconThemeData(color: DarkColors.onPrimary),
  titleTextStyle: _darkHeadlineTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardThemeData(
  color: DarkColors.primary,
  elevation: 1,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
  backgroundColor: DarkColors.accent,
  foregroundColor: DarkColors.onAccent,
  ),
  textTheme: _darkBodyTextTheme.copyWith(
  displayLarge: _darkHeadlineTextTheme.displayLarge,
  displayMedium: _darkHeadlineTextTheme.displayMedium,
  displaySmall: _darkHeadlineTextTheme.displaySmall,
  headlineLarge: _darkHeadlineTextTheme.headlineLarge,
  headlineMedium: _darkHeadlineTextTheme.headlineMedium,
  headlineSmall: _darkHeadlineTextTheme.headlineSmall,
  titleLarge: _darkHeadlineTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
  ),
  dialogBackgroundColor: DarkColors.primary,
  iconTheme: const IconThemeData(color: DarkColors.onPrimary),
  );
}