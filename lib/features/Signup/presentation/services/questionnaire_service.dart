import 'package:loginpage/features/Signup/domain/entites/question.dart';

class QuestionnaireService {
  void storeSelectedAnswersInUser(Map<int, String?> answers,
      List<Question> questions, Map<String, dynamic> userDetails) {
    Map<String, dynamic> questionnaireData = {};

    answers.forEach((questionId, answer) {
      final question = questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => const Question(0, '', [], ''),
      );
      questionnaireData[question.shortname] = answer;
    });

    if (userDetails.containsKey("questionnaire") &&
        userDetails["questionnaire"] is List) {
      if (userDetails["questionnaire"].isNotEmpty) {
        userDetails["questionnaire"]
            [0] = {...userDetails["questionnaire"][0], ...questionnaireData};
      } else {
        userDetails["questionnaire"].add(questionnaireData);
      }
    }
  }
}
