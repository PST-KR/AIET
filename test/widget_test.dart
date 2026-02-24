import 'package:flutter_test/flutter_test.dart';

import 'package:aise/data/lesson_data.dart';
import 'package:aise/main.dart';
import 'package:aise/models/quiz_item.dart';
import 'package:aise/utils/lesson_validator.dart';

void main() {
  testWidgets('home screen renders categories', (WidgetTester tester) async {
    final List<QuizItem> allItems = quizItems;
    final ValidationResult validationResult = validateQuizItems(allItems);
    final List<QuizItem> validItems = validationResult.validIndices
        .map((int index) => allItems[index])
        .toList(growable: false);

    await tester.pumpWidget(
      AiseApp(
        allItems: allItems,
        validItems: validItems,
        validationResult: validationResult,
      ),
    );

    expect(find.text('AI English Tutor'), findsOneWidget);
    expect(find.text('카테고리 선택'), findsOneWidget);
  });
}
