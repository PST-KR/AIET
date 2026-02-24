import 'package:flutter/material.dart';

import '../models/quiz_item.dart';
import '../utils/lesson_validator.dart';

class DevValidationScreen extends StatelessWidget {
  const DevValidationScreen({
    super.key,
    required this.allItems,
    required this.validationResult,
  });

  final List<QuizItem> allItems;
  final ValidationResult validationResult;

  @override
  Widget build(BuildContext context) {
    final int totalCount = allItems.length;
    final int validCount = validationResult.validIndices.length;
    final int invalidCount = totalCount - validCount;

    return Scaffold(
      appBar: AppBar(title: const Text('\uac80\uc99d \uacb0\uacfc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\uc804\uccb4 \ubb38\ud56d: $totalCount'),
            Text('\uc720\ud6a8 \ubb38\ud56d: $validCount'),
            Text('\ubb34\ud6a8 \ubb38\ud56d: $invalidCount'),
            const SizedBox(height: 16),
            Text(
              '\uc774\uc288 \ubaa9\ub85d',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: validationResult.issues.isEmpty
                  ? const Center(
                      child: Text(
                        '\uac80\uc99d \uc774\uc288\uac00 \uc5c6\uc2b5\ub2c8\ub2e4.',
                      ),
                    )
                  : ListView.separated(
                      itemCount: validationResult.issues.length,
                      separatorBuilder: (_, index) => const Divider(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final ValidationIssue issue =
                            validationResult.issues[index];
                        return Text('[${issue.index}] ${issue.reason}');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
