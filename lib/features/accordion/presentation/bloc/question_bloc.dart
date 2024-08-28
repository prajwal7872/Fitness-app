// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';
import 'package:loginpage/features/accordion/domain/usecases/validate_pageanswer.dart';
import '../../domain/usecases/select_answer.dart';
import 'question_event.dart';
import 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final GetQuestions getQuestions;
  final SelectAnswer selectAnswer;
  final ValidatePageAnswers validatePageAnswers;
  final PostUserDataUseCase postUserDataUseCase;

  QuestionBloc({
    required this.getQuestions,
    required this.selectAnswer,
    required this.validatePageAnswers,
    required this.postUserDataUseCase,
  }) : super(QuestionsLoading()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<AnswerSelected>(_onAnswerSelected);
    on<ChangeOpenSection>(_onChangeOpenSection);
    on<SetPageIndex>(_onSetPageIndex);
    on<ValidatePageAnswersEvent>(_onValidatePageAnswers);
    on<PostUserEvent>(
        _onPostUserEvent); // Moved PostUserEvent handling to a separate method
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<QuestionState> emit) {
    final questions = getQuestions();
    emit(QuestionsLoaded(questions, const {}, 0, 0, const {}, 0, false));
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final updatedAnswers =
          Map<int, String?>.from(currentState.selectedAnswers)
            ..[event.questionIndex] = event.answer;

      final allQuestionsAnswered = selectAnswer(
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

  void _onValidatePageAnswers(
      ValidatePageAnswersEvent event, Emitter<QuestionState> emit) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final allQuestionsAnswered = validatePageAnswers(
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

  void _onPostUserEvent(
      PostUserEvent event, Emitter<QuestionState> emit) async {
    try {
      print('build');
      await postUserDataUseCase.call(event.user);
      emit(UserSuccess());
    } catch (e) {
      final errorMessage = 'Failed to load data: ${e.toString()}';
      print(errorMessage);
      emit(UserFailure(errorMessage));
    }
  }
}
