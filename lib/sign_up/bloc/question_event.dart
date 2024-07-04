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
