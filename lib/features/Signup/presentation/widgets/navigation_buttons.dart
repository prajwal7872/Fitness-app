// navigation_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/Signup/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/Signup/presentation/bloc/question_state.dart';

class NavigationButtons extends StatelessWidget {
  final PageController pageController;
  final void Function(BuildContext, QuestionsLoaded) handlePreviousPage;
  final void Function(BuildContext, QuestionsLoaded) handleAnswerSelection;

  const NavigationButtons({
    super.key,
    required this.pageController,
    required this.handlePreviousPage,
    required this.handleAnswerSelection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        if (state is QuestionsLoaded) {
          final isLastPage = state.currentPageIndex >= 3;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                child: FloatingActionButton(
                  heroTag: 'previousButton',
                  backgroundColor:
                      state.currentPageIndex > 0 ? Colors.green : Colors.grey,
                  onPressed: () {
                    handlePreviousPage(context, state);
                  },
                  child: const Text(
                    'Previous',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: FloatingActionButton(
                  heroTag: 'nextButton',
                  backgroundColor:
                      state.allQuestionsAnswered ? Colors.green : Colors.grey,
                  onPressed: () {
                    handleAnswerSelection(context, state);
                  },
                  child: isLastPage
                      ? const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
