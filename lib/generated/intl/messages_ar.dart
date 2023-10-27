// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(pro) => "قاطع هذا ${pro} المنتج انه اسرائيلي";

  static String m1(pro) => "هل هذا ${pro} اسم المنتج";

  static String m2(pro) => "${pro} هذا  المنتج جيد جدا";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aNewVersionOfTheAppIsAvailableDoYou":
            MessageLookupByLibrary.simpleMessage(
                "يتوفر إصدار جديد من التطبيق. هل تريد التحديث الآن؟"),
        "anErrorOccurredWhileScanningText":
            MessageLookupByLibrary.simpleMessage(
                "حدث خطأ أثناء مسح النص ضوئيًا"),
        "boycottProduct": MessageLookupByLibrary.simpleMessage("أضف منتج"),
        "boycottThisProduct": m0,
        "cameraClosed": MessageLookupByLibrary.simpleMessage("تم غلق الكاميرا"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "clickToEnable": MessageLookupByLibrary.simpleMessage("أضغط للتفعيل"),
        "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
        "freedomForPalestine":
            MessageLookupByLibrary.simpleMessage(" الحرية لفلسطين"),
        "isThisTheProductName": m1,
        "israeli": MessageLookupByLibrary.simpleMessage("Israeli"),
        "requestPermission": MessageLookupByLibrary.simpleMessage(
            "تم رفض إذن الكاميرا \nيجب تفعيل اذن الكاميرا"),
        "scanProduct": MessageLookupByLibrary.simpleMessage("فحص المنتج"),
        "scanText": MessageLookupByLibrary.simpleMessage("مسح النص"),
        "send": MessageLookupByLibrary.simpleMessage("إرسال"),
        "someThingHappened": MessageLookupByLibrary.simpleMessage("حدث خطاء"),
        "successSend": MessageLookupByLibrary.simpleMessage("تم الارسال بنجاح"),
        "thisFieldRequired":
            MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
        "thisProductIsVeryGood": m2,
        "updateAvailable": MessageLookupByLibrary.simpleMessage("التحديث متاح"),
        "updateLater": MessageLookupByLibrary.simpleMessage("التحديث لاحقا"),
        "updateNow": MessageLookupByLibrary.simpleMessage("تحديث الان"),
        "yes": MessageLookupByLibrary.simpleMessage("نعم")
      };
}
