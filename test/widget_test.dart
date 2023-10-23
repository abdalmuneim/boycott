// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // List of strings to split on
    final List<dynamic> data = [
      {"id": 1, "text": "FS"},
      {"id": 2, "text": "EliteBook"},
      {"id": 3, "text": "Cherry"},
      {"id": 4, "text": "Grapes"},
      {"id": 5, "text": "Lemon"},
      {"id": 6, "text": "Orange"},
      {"id": 7, "text": "Strawberry"}
    ];

    // Large text to split
    String largeText = 'This is a large text with EliteBook, and banana.';
    // Output the split results with corresponding split items

    // Split the text based on each item in splitList

    splitTextWithList(largeText.toLowerCase(), data);

    print('f : $f');

    if (f.isNotEmpty) {
      print('Text found');
    } else {
      print('Text not found');
    }
  });
}

String f = '';
List<SplitResult> splitTextWithList(String text, List<dynamic> splitList) {
  List<SplitResult> splitResults = [SplitResult('', text.toLowerCase())];

  for (var splitItem in splitList) {
    List<SplitResult> newSplitResults = [];

    for (SplitResult result in splitResults) {
      List<String> textParts =
          result.splitText.split(splitItem['text'].toLowerCase());
      for (String part in textParts) {
        newSplitResults.add(SplitResult(splitItem['text'].toLowerCase(), part));
      }
      if (newSplitResults.length >= 2) {
        f = splitItem['text'].toLowerCase();
        return newSplitResults;
      }
    }
    splitResults = newSplitResults;
  }

  return splitResults;
}

class SplitResult {
  final String splitItem;
  final String splitText;

  SplitResult(this.splitItem, this.splitText);
}
