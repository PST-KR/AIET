import '../models/quiz_item.dart';

class ValidationIssue {
  const ValidationIssue({required this.index, required this.reason});

  final int index;
  final String reason;
}

class ValidationResult {
  const ValidationResult({required this.issues, required this.validIndices});

  final List<ValidationIssue> issues;
  final List<int> validIndices;
}

ValidationResult validateQuizItems(List<QuizItem> items) {
  final Map<int, List<String>> issuesByIndex = <int, List<String>>{};

  void addIssue(int index, String reason) {
    issuesByIndex.putIfAbsent(index, () => <String>[]).add(reason);
  }

  for (int i = 0; i < items.length; i++) {
    final QuizItem item = items[i];
    final int blankCount = RegExp(
      '____',
    ).allMatches(item.sentenceWithBlank).length;

    if (blankCount != 1) {
      addIssue(i, 'sentenceWithBlank must contain "____" exactly once.');
    }

    if (item.answer.trim().isEmpty) {
      addIssue(i, 'answer is empty.');
    }

    if (item.fullSentence.trim().isEmpty) {
      addIssue(i, 'fullSentence is empty.');
    }

    if (item.koreanTranslation.trim().isEmpty) {
      addIssue(i, 'koreanTranslation is empty.');
    }

    if (item.fullSentence.length > 120) {
      addIssue(i, 'fullSentence is longer than 120 characters.');
    }

    if (item.answer.trim().isNotEmpty && item.fullSentence.trim().isNotEmpty) {
      final String answerLower = item.answer.toLowerCase();
      final String fullLower = item.fullSentence.toLowerCase();

      if (!fullLower.contains(answerLower) &&
          !_containsWordsInOrder(fullLower, answerLower)) {
        addIssue(i, 'fullSentence does not contain answer text in sequence.');
      }
    }
  }

  final Map<String, List<int>> bySentence = <String, List<int>>{};
  for (int i = 0; i < items.length; i++) {
    final String normalized = items[i].fullSentence.trim().toLowerCase();
    if (normalized.isEmpty) {
      continue;
    }
    bySentence.putIfAbsent(normalized, () => <int>[]).add(i);
  }

  for (final List<int> indices in bySentence.values) {
    if (indices.length > 1) {
      for (final int index in indices) {
        addIssue(index, 'Duplicate fullSentence found (case-insensitive).');
      }
    }
  }

  final List<ValidationIssue> issues = <ValidationIssue>[];
  for (final int index in issuesByIndex.keys.toList()..sort()) {
    for (final String reason in issuesByIndex[index]!) {
      issues.add(ValidationIssue(index: index, reason: reason));
    }
  }

  final List<int> validIndices = <int>[];
  for (int i = 0; i < items.length; i++) {
    if (!issuesByIndex.containsKey(i)) {
      validIndices.add(i);
    }
  }

  return ValidationResult(issues: issues, validIndices: validIndices);
}

bool _containsWordsInOrder(String fullSentence, String answer) {
  final List<String> answerWords = answer
      .split(RegExp(r'\s+'))
      .map((String word) => word.trim())
      .where((String word) => word.isNotEmpty)
      .toList(growable: false);

  if (answerWords.isEmpty) {
    return false;
  }

  int cursor = 0;
  for (final String word in answerWords) {
    final int foundIndex = fullSentence.indexOf(word, cursor);
    if (foundIndex == -1) {
      return false;
    }
    cursor = foundIndex + word.length;
  }

  return true;
}
