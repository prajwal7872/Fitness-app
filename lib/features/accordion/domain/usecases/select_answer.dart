import 'package:loginpage/features/accordion/domain/entites/question.dart';

class SelectAnswer {
  bool call(Map<int, String?> selectedAnswers, List<Question> questions,
      int pageIndex) {
    final startIndex = pageIndex * 3;
    final endIndex = (pageIndex * 3 + 3).clamp(0, questions.length);

    for (int i = startIndex; i < endIndex; i++) {
      if (selectedAnswers[questions[i].id] == null) {
        return false;
      }
    }
    return true;
  }
}
