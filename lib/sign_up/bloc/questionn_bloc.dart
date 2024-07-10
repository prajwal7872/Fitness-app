import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/question_state.dart';
import 'package:loginpage/sign_up/models/question.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionsLoading()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<AnswerSelected>(_onAnswerSelected);
    on<ChangeOpenSection>(_onChangeOpenSection);
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<QuestionState> emit) {
    const questions = [
      Question(
          'Do you have any Chronic health condition? (e.g, diabetes,hypertenstion)',
          ['Yes', 'No']),
      Question(
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
          'How often do you currently exercise? (Experienced and long term fitness freak)',
          ['Never', 'Regularly', '2-3 times a week']),
      Question('What type of physical activities do you typically engage in?',
          ['Walking', 'Running', 'Cycling', 'Swimming', 'Weight Training']),
      Question(
          'How often do you experience symptoms related to your chronic conditions?',
          ['Daily', 'Weekly', 'Monthly', 'Rarely/Never']),
      Question(
          'Do you have a family history of any major illnesses', ['Yes', 'No']),
      Question('Do you have any known allergies?', ['Yes', 'No']),
      Question('Have you had any surgeries in the past?', ['Yes', 'No']),
    ];

    emit(const QuestionsLoaded(questions, {}, 0, 0));
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final updatedAnswers =
          Map<int, String?>.from(currentState.selectedAnswers)
            ..[event.questionIndex] = event.answer;

      emit(QuestionsLoaded(currentState.questions, updatedAnswers,
          currentState.openSectionIndex, currentState.currentIndex));
    }
  }

  void _onChangeOpenSection(
      ChangeOpenSection event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      emit(QuestionsLoaded(currentState.questions, currentState.selectedAnswers,
          event.newIndex, currentState.currentIndex));
    }
  }
}
