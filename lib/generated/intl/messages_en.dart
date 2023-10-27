// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(pro) => "Boycott this ${pro} Product because it is Israeli.";

  static String m1(pro) => "Is this ${pro} the name of the product";

  static String m2(pro) => "This ${pro} product is very good";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "anErrorOccurredWhileScanningText":
            MessageLookupByLibrary.simpleMessage(
                "An error occurred while scanning text"),
        "boycottProduct": MessageLookupByLibrary.simpleMessage("Add Product"),
        "boycottThisProduct": m0,
        "cameraClosed": MessageLookupByLibrary.simpleMessage("CLosed Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "clickToEnable":
            MessageLookupByLibrary.simpleMessage("Click to Enable"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "freedomForPalestine":
            MessageLookupByLibrary.simpleMessage("Freedom for Palestine "),
        "isThisTheProductName": m1,
        "israeli": MessageLookupByLibrary.simpleMessage("Israeli"),
        "requestPermission": MessageLookupByLibrary.simpleMessage(
            "Camera permission denied.\nCamera permission must be enabled."),
        "scanProduct": MessageLookupByLibrary.simpleMessage("Scan Product"),
        "scanText": MessageLookupByLibrary.simpleMessage("Scan Text"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "someThingHappened":
            MessageLookupByLibrary.simpleMessage("Something happened"),
        "successSend":
            MessageLookupByLibrary.simpleMessage("Sent successfully"),
        "thisFieldRequired":
            MessageLookupByLibrary.simpleMessage("This field is required"),
        "thisProductIsVeryGood": m2,
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
