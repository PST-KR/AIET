import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/quiz_item.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    required this.category,
    required this.validItems,
  });

  final Category category;
  final List<QuizItem> validItems;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final TextEditingController _answerController = TextEditingController();

  late final List<QuizItem> _items;
  int _currentIndex = 0;
  bool _isChecked = false;
  bool _isCorrect = false;

  QuizItem get _currentItem => _items[_currentIndex];

  @override
  void initState() {
    super.initState();
    _items = widget.validItems
        .where((QuizItem item) => item.categoryId == widget.category.id)
        .toList(growable: false);
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final String userInput = _answerController.text.trim().toLowerCase();
    final String correctAnswer = _currentItem.answer.trim().toLowerCase();

    setState(() {
      _isChecked = true;
      _isCorrect = userInput == correctAnswer;
    });
  }

  void _nextItem() {
    if (_items.isEmpty) {
      return;
    }

    setState(() {
      _currentIndex = (_currentIndex + 1) % _items.length;
      _isChecked = false;
      _isCorrect = false;
      _answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.name)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              '연습 가능한 문항이 없습니다.\n데이터 검증 화면에서 이슈를 확인해 주세요.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final QuizItem item = _currentItem;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '문장 ${_currentIndex + 1} / ${_items.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              item.sentenceWithBlank,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              item.koreanTranslation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: '정답 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _isChecked ? null : _checkAnswer,
                  child: const Text('정답 확인'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _nextItem, child: const Text('다음')),
              ],
            ),
            const SizedBox(height: 16),
            if (_isChecked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isCorrect
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCorrect ? '정답입니다!' : '오답입니다.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('정답 문장: ${item.fullSentence}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
