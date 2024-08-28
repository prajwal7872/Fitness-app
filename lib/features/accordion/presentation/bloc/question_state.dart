import 'package:equatable/equatable.dart';
import 'package:loginpage/features/accordion/domain/entites/question.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionsLoading extends QuestionState {}

class QuestionsLoaded extends QuestionState {
  final List<Question> questions;
  final Map<int, String?> selectedAnswers;
  final int openSectionIndex;
  final int currentIndex;
  final Set<int> pageIndexes;
  final int currentPageIndex;
  final bool allQuestionsAnswered;

  const QuestionsLoaded(
    this.questions,
    this.selectedAnswers,
    this.openSectionIndex,
    this.currentIndex,
    this.pageIndexes,
    this.currentPageIndex,
    this.allQuestionsAnswered,
  );

  @override
  List<Object> get props => [
        questions,
        selectedAnswers,
        openSectionIndex,
        currentIndex,
        pageIndexes,
        currentPageIndex,
        allQuestionsAnswered,
      ];
}

class QuestionsError extends QuestionState {
  final String message;

  const QuestionsError(this.message);

  @override
  List<Object> get props => [message];
}

class UserSuccess extends QuestionState {}

class UserFailure extends QuestionState {
  final String message;

  const UserFailure(this.message);
}
