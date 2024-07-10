// ignore_for_file: avoid_print

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

  void _showValidationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Something Went Wrong',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Please answer all questions before proceeding.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleAnswerSelection(
      BuildContext context, int index, String value, int id) {
    print('inside handle answer $index $id $value');

    // context.read<QuestionBloc>().add(AnswerSelected(index, value));
    context.read<QuestionBloc>().add(AnswerSelected(id, value));
    var updatedAnswers = Map<int, String?>.from(selectedAnswers)..[id] = value;

    print('updatedAns $updatedAnswers');

    // Calculate the start and end index of the current page
    final currentPage = (index / 3).floor();
    final startIndex = currentPage * 3;
    final endIndex = (currentPage * 3 + 3).clamp(0, questions.length);

    // Check if all questions on the current page are answered
    bool allQuestionsOnCurrentPageAnswered = true;
    for (int i = startIndex; i < endIndex; i++) {
      var updatedanswers = updatedAnswers[questions[i].id];
      print("updatedAnswers[i] $updatedanswers");
      if (updatedAnswers[questions[i].id] == null) {
        allQuestionsOnCurrentPageAnswered = false;

        break;
      }
    }

    // If all questions on the current page are answered, navigate to the next page
    if (allQuestionsOnCurrentPageAnswered) {
      print(
          "allQuestionsOnCurrentPageAnswered $allQuestionsOnCurrentPageAnswered");
      context.read<QuestionBloc>().add(ChangeOpenSection(index + 1));
      print('pageIndex $pageIndex');
      context.read<QuestionBloc>().add(SetPageIndex(pageIndex));
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Ensure the open section is reset or handled correctly after navigation
    } else if (index < questions.length - 1) {
      context.read<QuestionBloc>().add(ChangeOpenSection(index + 1));
    } else {
      _showValidationDialog(context);
    }
  }

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
                    _handleAnswerSelection(context, index, value, id);
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
