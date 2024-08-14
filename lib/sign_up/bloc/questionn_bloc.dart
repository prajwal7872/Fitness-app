import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/question_state.dart';
import 'package:loginpage/sign_up/models/question.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionsLoading()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<AnswerSelected>(_onAnswerSelected);
    on<ChangeOpenSection>(_onChangeOpenSection);
    on<SetPageIndex>(_onSetPageIndex);
    on<UpdateCurrentPageIndex>(_onUpdateCurrentPageIndex);
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<QuestionState> emit) {
    const questions = [
      Question(
          1,
          'Do you have any Chronic health condition? (e.g, diabetes,hypertension)',
          ['Yes', 'None'],
          'chronic_health'),
      Question(
          2,
          'Do you follow any specific diet plan? (e.g, vegan,keto,gluten-free)',
          [
            'Balanced',
            'Vegan',
            'Vegetarian',
            'Keto',
            'Paleo',
            'Gluten-free',
            'Low-carb'
          ],
          'diet_plan'),
      Question(3, 'What is your Fitness Goal?',
          ['Lose Weight', 'Gain Weight', 'Stay Same'], 'fitness_goal'),
      Question(
          4,
          'What type of physical activities do you typically engage in?',
          ['Walking', 'Running', 'Cycling', 'Swimming', 'Weight Training'],
          'physical_activities'),
      Question(5, 'What is your Occupation?',
          ['Student', 'It Oficer', 'Teacher'], 'occupation'),
      Question(6, 'How much do you sleep in night?',
          ['4-5 hours', '6-8hours', 'more than 10hours'], "sleep"),
      Question(7, 'What is your fitness Level?',
          ['Advance', 'Intermediate', 'Basic'], 'fitnesslevel'),
      Question(8, 'How much is your Weight?', ['Below 50', '60-80 ', '80-110'],
          'weight'),
      Question(9, 'How much is your Height (in meter)',
          ['150', '160-180', '180-220'], 'height'),
      Question(10, 'What is your Gender?', ['Male', 'Female'], 'gender'),
      Question(
          11,
          'Please give us your progress feedback!',
          ['None', 'little progress', 'little progresss!'],
          'progress_feedback'),
      Question(
          12,
          'Do you have any chrinoc health condition? (e.g Diabetes,hypertension)',
          ['Yes', 'Nones'],
          'health_condition'),
    ];

    emit(const QuestionsLoaded(questions, {}, 0, 0, {}, 0, false));
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final updatedAnswers =
          Map<int, String?>.from(currentState.selectedAnswers)
            ..[event.questionIndex] = event.answer;

      final allQuestionsAnswered = _areAllQuestionsAnswered(
        updatedAnswers,
        currentState.questions,
        currentState.currentPageIndex,
      );

      emit(QuestionsLoaded(
        currentState.questions,
        updatedAnswers,
        currentState.openSectionIndex,
        currentState.currentIndex,
        currentState.pageIndexes,
        currentState.currentPageIndex,
        allQuestionsAnswered,
      ));
    }
  }

  void _onChangeOpenSection(
      ChangeOpenSection event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      emit(QuestionsLoaded(
        currentState.questions,
        currentState.selectedAnswers,
        event.newIndex,
        currentState.currentIndex,
        currentState.pageIndexes,
        currentState.currentPageIndex,
        currentState.allQuestionsAnswered,
      ));
    }
  }

  void _onSetPageIndex(SetPageIndex event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final updatedPageIndexes = Set<int>.from(currentState.pageIndexes)
        ..add(event.pageIndex);
      emit(QuestionsLoaded(
        currentState.questions,
        currentState.selectedAnswers,
        currentState.openSectionIndex,
        currentState.currentIndex,
        updatedPageIndexes,
        currentState.currentPageIndex,
        currentState.allQuestionsAnswered,
      ));
    }
  }

  void _onUpdateCurrentPageIndex(
      UpdateCurrentPageIndex event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final allQuestionsAnswered = _areAllQuestionsAnswered(
        currentState.selectedAnswers,
        currentState.questions,
        event.currentPageIndex,
      );

      emit(QuestionsLoaded(
        currentState.questions,
        currentState.selectedAnswers,
        currentState.openSectionIndex,
        currentState.currentIndex,
        currentState.pageIndexes,
        event.currentPageIndex,
        allQuestionsAnswered,
      ));
    }
  }

  bool _areAllQuestionsAnswered(
      Map<int, String?> answers, List<Question> questions, int pageIndex) {
    final startIndex = pageIndex * 3;
    final endIndex = (pageIndex * 3 + 3).clamp(0, questions.length);

    for (int i = startIndex; i < endIndex; i++) {
      if (answers[questions[i].id] == null) {
        return false;
      }
    }
    return true;
  }
}
