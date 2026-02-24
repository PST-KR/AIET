import 'dart:io';

import 'package:aise/data/lesson_data.dart';
import 'package:aise/utils/lesson_validator.dart';

void main() {
  final result = validateQuizItems(quizItems);
  stdout.writeln('total count: ${quizItems.length}');
  stdout.writeln('valid count: ${result.validIndices.length}');
  stdout.writeln('issue count: ${result.issues.length}');
}
