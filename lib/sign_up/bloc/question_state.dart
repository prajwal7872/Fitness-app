import 'package:equatable/equatable.dart';
import 'package:loginpage/sign_up/models/question.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionsLoading extends QuestionState {}

class QuestionsLoaded extends QuestionState {
  final List<Question> questions;
  final Map<int, String?> selectedAnswers;

  const QuestionsLoaded(this.questions, this.selectedAnswers);

  @override
  List<Object> get props => [questions, selectedAnswers];
}

class QuestionsError extends QuestionState {
  final String message;

  const QuestionsError(this.message);

  @override
  List<Object> get props => [message];
}
