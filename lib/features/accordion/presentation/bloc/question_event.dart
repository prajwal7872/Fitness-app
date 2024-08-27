import 'package:equatable/equatable.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestions extends QuestionEvent {}

class AnswerSelected extends QuestionEvent {
  final int questionIndex;
  final String answer;

  const AnswerSelected(this.questionIndex, this.answer);

  @override
  List<Object> get props => [questionIndex, answer];
}

class ChangeOpenSection extends QuestionEvent {
  final int newIndex;

  const ChangeOpenSection(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}

class SetPageIndex extends QuestionEvent {
  final int pageIndex;

  const SetPageIndex(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

class ValidatePageAnswersEvent extends QuestionEvent {
  final int currentPageIndex;

  const ValidatePageAnswersEvent(this.currentPageIndex);

  @override
  List<Object> get props => [currentPageIndex];
}
