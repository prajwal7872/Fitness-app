import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:loginpage/sign_up/bloc/questionn_bloc.dart';
import 'package:loginpage/sign_up/models/question.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/question_state.dart';
import 'package:loginpage/sign_up/widgets/custom_accordion_section.dart';

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
              int id = questionData.id;
              Color contentBgColor;
              Color headerBgColor;

              switch (index % 6) {
                case 0:
                  contentBgColor = Colors.transparent;
                  headerBgColor = const Color.fromARGB(255, 208, 230, 249);
                  break;
                case 1:
                  contentBgColor = Colors.transparent;
                  headerBgColor = const Color.fromARGB(255, 251, 236, 97);
                  break;
                case 2:
                  contentBgColor = Colors.transparent;
                  headerBgColor = Colors.lightBlueAccent;
                  break;

                default:
                  contentBgColor = Colors.transparent;
                  headerBgColor = Colors.pinkAccent;
                  break;
              }

              return CustomAccordionSection(
                isOpen: state.openSectionIndex == index,
                contentBackgroundColor: contentBgColor,
                headerBackgroundColor: headerBgColor,
                question: questionData.question,
                answers: questionData.answers,
                selectedAnswer: selectedAnswers[id],
                onChanged: (String? value) {
                  if (value != null) {
                    context.read<QuestionBloc>().add(AnswerSelected(id, value));
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
}
