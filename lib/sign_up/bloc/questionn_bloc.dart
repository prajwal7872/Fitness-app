// ignore_for_file: avoid_print

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
          ['Yes', 'No']),
      Question(
          2,
          'Do you follow any specific diet plan? (e.g, vegan,keto,gluten-free)',
          [
            'None',
            'Vegan',
            'Vegetarian',
            'Keto',
            'Paleo',
            'Gluten-free',
            'Low-carb'
          ]),
      Question(
          3,
          'How often do you currently exercise? (Experienced and long term fitness freak)',
          ['Never', 'Regularly', '2-3 times a week']),
      Question(
          4,
          'What type of physical activities do you typically engage in?',
          ['Walking', 'Running', 'Cycling', 'Swimming', 'Weight Training']),
      Question(
          5,
          'How often do you experience symptoms related to your chronic conditions?',
          ['Daily', 'Weekly', 'Monthly', 'Rarely/Never']),
      Question(6, 'Do you have a family history of any major illnesses?',
          ['Yes', 'No']),
      Question(7, 'Do you have any known allergies?', ['Yes', 'No']),
      Question(8, 'Have you had any surgeries in the past?', ['Yes', 'No']),
      Question(9, 'Hello hello', ['Yo', 'Ho']),
      Question(10, 'Do you have?', ['Yes', 'No']),
      Question(11, 'Have you had?', ['Yes', 'No']),
      Question(12, 'Hello', ['Yoo', 'Hoooo']),
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
    Map<int, String?> answers,
    List<Question> questions,
    int pageIndex,
  ) {
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
