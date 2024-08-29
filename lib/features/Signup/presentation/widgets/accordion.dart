import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/Signup/domain/entites/question.dart';
import 'package:loginpage/features/Signup/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/Signup/presentation/bloc/question_event.dart';
import 'package:loginpage/features/Signup/presentation/bloc/question_state.dart';
import 'package:loginpage/features/Signup/presentation/widgets/custom_accordion.dart';

class AccordionWidget extends StatelessWidget {
  final int pageIndex;
  final List<Question> questions;
  final Map<int, String?> selectedAnswers;
  final PageController pageController;

  const AccordionWidget({
    super.key,
    required this.pageIndex,
    required this.questions,
    required this.selectedAnswers,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        if (state is QuestionsLoaded) {
          return Accordion(
            children: questions.asMap().entries.map((entry) {
              int index = entry.key;
              Question questionData = entry.value;
              return CustomAccordionSection(
                isOpen: state.openSectionIndex == index,
                contentBackgroundColor: Colors.transparent,
                headerBackgroundColor: _getHeaderColor(index),
                question: questionData.question,
                answers: questionData.answers,
                selectedAnswer: selectedAnswers[questionData.id],
                onChanged: (String? value) {
                  if (value != null) {
                    context
                        .read<QuestionBloc>()
                        .add(AnswerSelected(questionData.id, value));
                    context
                        .read<QuestionBloc>()
                        .add(ChangeOpenSection(index + 1));
                  }
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Color _getHeaderColor(int index) {
    switch (index % 6) {
      case 0:
        return Colors.lightBlueAccent;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.pinkAccent;
    }
  }
}
