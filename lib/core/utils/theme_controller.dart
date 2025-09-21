import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//==============================================================================
// ThemeController: العقل المدبر للتحكم في مظهر التطبيق
//==============================================================================
// [مهم للمناقشة]
// هذا الـ Controller هو المسؤول عن وظيفة واحدة ومهمة: تبديل المظهر (فاتح/داكن)
// وحفظ اختيار المستخدم في ذاكرة الهاتف الدائمة.
//
// لماذا نستخدم Controller منفصل؟
// 1. فصل الاهتمامات: منطق التحكم في المظهر معزول تمامًا عن الواجهة.
// 2. سهولة الوصول: يمكن الوصول إلى هذا الـ Controller من أي مكان في التطبيق
//    بسهولة باستخدام Get.find<ThemeController>().
//==============================================================================
class ThemeController extends GetxController {
  // --- 1. إعداد ذاكرة التخزين الدائمة (Permanent Storage) ---

  // [مهم للمناقشة]
  // نستخدم هنا حزمة get_storage، وهي حل بسيط وسريع من نفس مطوري GetX
  // لحفظ البيانات البسيطة (مثل الإعدادات) في ذاكرة الهاتف.
  // هي بديل أسهل لـ shared_preferences.
  final _box = GetStorage();

  // _key هو المفتاح الذي سنستخدمه لحفظ واسترجاع قيمة حالة المظهر.
  // استخدام متغير للمفتاح يمنع الأخطاء الإملائية.
  final _key = 'isDarkMode';

  // --- 2. دوال القراءة من الذاكرة وتطبيق المظهر ---

  // getter بسيط لجلب المظهر الحالي.
  // عندما يطلب التطبيق themeController.theme، سيتم تنفيذ هذا الكود.
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // دالة خاصة (private) لقراءة القيمة من GetStorage.
  // _box.read(_key) تقرأ القيمة المرتبطة بالمفتاح 'isDarkMode'.
  // ?? false تعني: "إذا كانت القيمة غير موجودة (null)، استخدم false كقيمة افتراضية".
  // هذا يحدث فقط في المرة الأولى التي يتم فيها تشغيل التطبيق.
  bool _loadThemeFromBox() => _box.read(_key) ?? false; // Default to light mode

  // --- 3. دوال الحفظ في الذاكرة وتغيير المظهر ---

  // دالة خاصة لحفظ القيمة الجديدة في GetStorage.
  // _box.write(key, value) تقوم بحفظ القيمة isDarkMode تحت المفتاح _key.
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // [مهم للمناقشة]
  // هذه هي الدالة العامة التي يتم استدعاؤها عند الضغط على زر تبديل المظهر.
  void switchTheme() {
    // Get.changeThemeMode() هي دالة من GetX تقوم بتغيير مظهر التطبيق فعليًا.
    // نقوم بقراءة القيمة الحالية من الذاكرة وعكسها.
    // إذا كان المظهر الحالي داكنًا (true)، قم بتغييره إلى فاتح (ThemeMode.light).
    // وإذا كان فاتحًا (false)، قم بتغييره إلى داكن (ThemeMode.dark).
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);

    // بعد تغيير المظهر في الواجهة، نقوم بحفظ الحالة الجديدة في الذاكرة.
    // !_loadThemeFromBox() تقوم بعكس القيمة الحالية (true -> false, false -> true)
    // وحفظها، لتكون جاهزة للمرة القادمة التي يتم فيها تشغيل التطبيق.
    _saveThemeToBox(!_loadThemeFromBox());
  }
}