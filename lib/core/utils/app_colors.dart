import 'package:flutter/material.dart';

//==============================================================================
// ملف تعريف لوحة الألوان (Color Palette)
//==============================================================================
// [مهم للمناقشة]
// الغرض من هذا الملف: هو فصل الألوان عن بقية كود التصميم (app_themes.dart).
// هذه ممارسة ممتازة تسمى "Separation of Concerns" (فصل الاهتمامات).
//
// الفائدة:
// 1. سهولة التعديل: إذا أردت تغيير لون معين في المستقبل، ستغيره في مكان واحد فقط هنا.
// 2. تنظيم الكود: يجعل الكود أكثر نظافة وقابلية للقراءة.
// 3. إعادة الاستخدام: يمكن استخدام هذه الألوان في أي مكان في التطبيق بسهولة.
//==============================================================================


// =================================================================
// Light Theme Colors - ألوان المظهر الفاتح
// =================================================================
// هذه الفئة (Class) تحتوي على كل تعريفات الألوان المستخدمة في المظهر الفاتح.
class LightColors {
  // static const تعني أن هذه القيمة ثابتة ولا تتغير، ويمكن الوصول إليها
  // مباشرة من الفئة بدون الحاجة لإنشاء كائن منها (e.g., LightColors.primary).

  // اللون الأبيض لخلفية البطاقات والأسطح البارزة.
  static const Color primary = Color(0xFFFFFFFF); // Card, Surface Color

  // اللون الأسود الداكن للنصوص التي تظهر فوق الأسطح البيضاء.
  static const Color onPrimary = Color(0xFF1C1C1C); // Text Color

  // اللون الرمادي الفاتح جدًا لخلفية الشاشة الرئيسية (Scaffold).
  static const Color secondary = Color(0xFFF5F5F5); // Background Color

  // لون النصوص على الخلفية الرمادية (نفس لون onPrimary للتوحيد).
  static const Color onSecondary = Color(0xFF1C1C1C); // Text Color

  // [مهم للمناقشة]
  // اللون الذهبي المميز (Accent Color). يستخدم لجذب انتباه المستخدم
  // للعناصر التفاعلية المهمة مثل الأزرار والأيقونات.
  static const Color accent = Color(0xFFD4AF37); // Accent Color (e.g., Buttons, Icons)

  // اللون الأبيض للنصوص التي تظهر فوق اللون الذهبي المميز.
  static const Color onAccent = Color(0xFFFFFFFF); // Text on Accent Color

  // لون أحمر للدلالة على وجود خطأ.
  static const Color error = Color(0xFFB00020);
  // لون النص الذي يظهر فوق لون الخطأ.
  static const Color onError = Color(0xFFFFFFFF);
}

// =================================================================
// Dark Theme Colors - ألوان المظهر الداكن
// =================================================================
// هذه الفئة تحتوي على كل تعريفات الألوان المستخدمة في المظهر الداكن.
class DarkColors {
  // اللون الرمادي الداكن جدًا لخلفية البطاقات والأسطح البارزة.
  static const Color primary = Color(0xFF1E1E1E); // Card, Surface Color

  // اللون الرمادي الفاتح للنصوص التي تظهر فوق الأسطح الداكنة.
  static const Color onPrimary = Color(0xFFE0E0E0); // Text Color

  // اللون الأسود الكامل لخلفية الشاشة الرئيسية (لتحقيق تباين وعمق).
  static const Color secondary = Color(0xFF121212); // Background Color

  // لون النصوص على الخلفية السوداء.
  static const Color onSecondary = Color(0xFFE0E0E0); // Text Color

  // [مهم للمناقشة]
  // نفس اللون الذهبي المميز المستخدم في المظهر الفاتح.
  // الحفاظ على نفس الـ Accent Color بين المظهرين يعطي هوية بصرية ثابتة للتطبيق.
  static const Color accent = Color(0xFFD4AF37); // Accent Color (e.g., Buttons, Icons)

  // اللون الأسود للنصوص التي تظهر فوق اللون الذهبي (لتحقيق تباين عالٍ في الوضع الداكن).
  static const Color onAccent = Color(0xFF121212); // Text on Accent Color

  // لون أحمر فاتح للدلالة على وجود خطأ في الوضع الداكن.
  static const Color error = Color(0xFFCF6679);
  // لون النص الذي يظهر فوق لون الخطأ في الوضع الداكن.
  static const Color onError = Color(0xFF121212);
}