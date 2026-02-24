class QuizItem {
  const QuizItem({
    required this.categoryId,
    required this.sentenceWithBlank,
    required this.answer,
    required this.fullSentence,
    required this.koreanTranslation,
    this.hint,
  });

  final String categoryId;
  final String sentenceWithBlank;
  final String answer;
  final String fullSentence;
  final String koreanTranslation;
  final String? hint;
}
