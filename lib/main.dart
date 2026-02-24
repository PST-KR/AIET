import 'package:flutter/material.dart';

import 'data/lesson_data.dart';
import 'models/quiz_item.dart';
import 'screens/home_screen.dart';
import 'utils/lesson_validator.dart';

void main() {
  final List<QuizItem> allItems = quizItems;
  final ValidationResult validationResult = validateQuizItems(allItems);
  final List<QuizItem> validItems = validationResult.validIndices
      .map((int index) => allItems[index])
      .toList(growable: false);
  runApp(
    AiseApp(
      allItems: allItems,
      validItems: validItems,
      validationResult: validationResult,
    ),
  );
}

class AiseApp extends StatelessWidget {
  const AiseApp({
    super.key,
    required this.allItems,
    required this.validItems,
    required this.validationResult,
  });

  final List<QuizItem> allItems;
  final List<QuizItem> validItems;
  final ValidationResult validationResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI English Tutor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(
        allItems: allItems,
        validItems: validItems,
        validationResult: validationResult,
      ),
    );
  }
}
