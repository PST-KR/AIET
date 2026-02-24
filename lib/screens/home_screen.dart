import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../models/category.dart';
import '../models/quiz_item.dart';
import '../utils/lesson_validator.dart';
import 'dev_validation_screen.dart';
import 'practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.allItems,
    required this.validItems,
    required this.validationResult,
  });

  final List<QuizItem> allItems;
  final List<QuizItem> validItems;
  final ValidationResult validationResult;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _titleTapCount = 0;

  void _openDevValidationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DevValidationScreen(
          allItems: widget.allItems,
          validationResult: widget.validationResult,
        ),
      ),
    );
  }

  void _handleTitleTap() {
    setState(() {
      _titleTapCount += 1;
      if (_titleTapCount >= 7) {
        _titleTapCount = 0;
        _openDevValidationScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _handleTitleTap,
          onLongPress: _openDevValidationScreen,
          child: const Text('AI English Tutor'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\uce74\ud14c\uace0\ub9ac \uc120\ud0dd',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final Category category = categories[index];
                  return FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => PracticeScreen(
                            category: category,
                            validItems: widget.validItems,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(category.name),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
