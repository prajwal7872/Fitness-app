import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/domain/entites/userdetails.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_state.dart';
import 'package:loginpage/features/accordion/presentation/services/questionnaire_service.dart';
import 'package:loginpage/features/meal/presentation/pages/meal_screen.dart';

class QuestionnaireNavigationHelper {
  final PageController pageController;
  final Map<String, dynamic> userDetails;
  final PostUserDataUseCase postUserDataUseCase;

  QuestionnaireNavigationHelper({
    required this.pageController,
    required this.userDetails,
    required this.postUserDataUseCase,
  });

  void handleAnswerSelection(
      BuildContext context, QuestionsLoaded state) async {
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
        print(userDetails);

        context.read<QuestionBloc>().add(PostUserEvent(User(
              email: userDetails['email'],
              password: userDetails['password'],
              fullName: userDetails['full_name'],
              contactNo: userDetails['contact_no'],
              dateOfBirth: DateTime.parse(userDetails['date_of_birth']),
              questionnaire: Questionnaire(
                chronicHealth: userDetails['questionnaire'][0]
                    ['chronic_health'],
                dietPlan: userDetails['questionnaire'][0]['diet_plan'],
                fitnessGoal: userDetails['questionnaire'][0]['fitness_goal'],
                physicalActivities: userDetails['questionnaire'][0]
                    ['physical_activities'],
                occupation: userDetails['questionnaire'][0]['occupation'],
                sleep: userDetails['questionnaire'][0]['sleep'],
                fitnessLevel: userDetails['questionnaire'][0]['fitnesslevel'],
                weight: userDetails['questionnaire'][0]['weight'],
                height: userDetails['questionnaire'][0]['height'],
                gender: userDetails['questionnaire'][0]['gender'],
                progressFeedback: userDetails['questionnaire'][0]
                    ['progress_feedback'],
                healthCondition: userDetails['questionnaire'][0]
                    ['health_condition'],
              ),
            )));

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
