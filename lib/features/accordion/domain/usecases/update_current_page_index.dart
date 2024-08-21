import 'package:loginpage/features/accordion/domain/entites/question.dart';
import 'package:loginpage/features/accordion/domain/usecases/select_answer.dart';

class UpdateCurrentPageIndexUseCase {
  final SelectAnswer selectAnswer;

  UpdateCurrentPageIndexUseCase(this.selectAnswer);

  bool call(Map<int, String?> selectedAnswers, List<Question> questions,
      int currentPageIndex) {
    final startIndex = currentPageIndex * 3;
    final endIndex = (currentPageIndex * 3 + 3).clamp(0, questions.length);

    for (int i = startIndex; i < endIndex; i++) {
      if (selectedAnswers[questions[i].id] == null) {
        return false;
      }
    }
    return true;
  }
}
