import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/data/model/user_details_mode.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_state.dart';
import 'package:loginpage/features/accordion/presentation/services/questionnaire_service.dart';
import 'package:loginpage/features/meal/presentation/pages/meal_screen.dart';

class QuestionnaireNavigationHelper {
  final PageController pageController;
  final Map<String, dynamic> userDetails;

  QuestionnaireNavigationHelper({
    required this.pageController,
    required this.userDetails,
  });

  void handleAnswerSelection(BuildContext context, QuestionsLoaded state) {
    final updatedAnswers = Map<int, String?>.from(state.selectedAnswers);

    QuestionnaireService().storeSelectedAnswersInUser(
        updatedAnswers, state.questions, userDetails);

    final currentPage = pageController.page!.toInt();
    final startIndex = currentPage * 3;
    final endIndex = (currentPage * 3 + 3).clamp(0, state.questions.length);

    bool allQuestionsOnCurrentPageAnswered = true;
    for (int i = startIndex; i < endIndex; i++) {
      if (updatedAnswers[state.questions[i].id] == null) {
        allQuestionsOnCurrentPageAnswered = false;
        break;
      }
    }
    if (allQuestionsOnCurrentPageAnswered) {
      if (currentPage >= (state.questions.length / 3).ceil() - 1) {
        final userDetails = UserDetails(
          email: 'email',
          password: 'password',
          fullName: 'fullname',
          contactNo: 'contactNo',
          dateOfBirth: 'dateOfBirth',
          questionnaire: state.questions
              .map((q) => Questionnaire(
                    chronicHealth: updatedAnswers[1] ?? '',
                    dietPlan: updatedAnswers[2] ?? '',
                    fitnessGoal: updatedAnswers[3] ?? '',
                    physicalActivities: updatedAnswers[4] ?? '',
                    occupation: updatedAnswers[5] ?? '',
                    sleep: updatedAnswers[6] ?? '',
                    fitnessLevel: updatedAnswers[7] ?? '',
                    weight: updatedAnswers[8] ?? '',
                    height: updatedAnswers[9] ?? '',
                    gender: updatedAnswers[10] ?? '',
                    progressFeedback: updatedAnswers[11] ?? '',
                    healthCondition: updatedAnswers[12] ?? '',
                  ))
              .toList(),
        );

        context.read<QuestionBloc>().add(PostUserDetailsEvent(userDetails));

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MealPlanScreen(),
        ));
      } else {
        context.read<QuestionBloc>().add(ChangeOpenSection(currentPage + 1));
        context.read<QuestionBloc>().add(SetPageIndex(currentPage + 1));
        context
            .read<QuestionBloc>()
            .add(ValidatePageAnswersEvent(currentPage + 1));

        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please answer all questions.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void handlePreviousPage(BuildContext context, QuestionsLoaded state) {
    final currentPage = pageController.page!.toInt();

    if (currentPage > 0) {
      context.read<QuestionBloc>().add(ChangeOpenSection(currentPage - 1));
      context.read<QuestionBloc>().add(SetPageIndex(currentPage - 1));
      context
          .read<QuestionBloc>()
          .add(ValidatePageAnswersEvent(currentPage - 1));

      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
