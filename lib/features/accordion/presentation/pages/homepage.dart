import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_state.dart';
import 'package:loginpage/features/accordion/presentation/services/questionnaire_service.dart';
import 'package:loginpage/features/accordion/presentation/widgets/accordion.dart';
import 'package:loginpage/features/accordion/presentation/widgets/navigation_buttons.dart';
import 'package:loginpage/features/accordion/presentation/widgets/timeline_tile.dart';
import 'package:loginpage/features/mealplan/Screens/meal_screen.dart';

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const MyHomePage({super.key, required this.userDetails});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();

  void _handleAnswerSelection(BuildContext context, QuestionsLoaded state) {
    final updatedAnswers = Map<int, String?>.from(state.selectedAnswers);

    QuestionnaireService().storeSelectedAnswersInUser(
        updatedAnswers, state.questions, widget.userDetails);

    final currentPage = _pageController.page!.toInt();
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
        print(widget.userDetails);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MealPlanScreen(),
        ));
      } else {
        context.read<QuestionBloc>().add(ChangeOpenSection(currentPage + 1));
        context.read<QuestionBloc>().add(SetPageIndex(currentPage + 1));
        context
            .read<QuestionBloc>()
            .add(UpdateCurrentPageIndex(currentPage + 1));

        _pageController.nextPage(
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

  void _handlePreviousPage(BuildContext context, QuestionsLoaded state) {
    final currentPage = _pageController.page!.toInt();

    if (currentPage > 0) {
      context.read<QuestionBloc>().add(ChangeOpenSection(currentPage - 1));
      context.read<QuestionBloc>().add(SetPageIndex(currentPage - 1));
      context.read<QuestionBloc>().add(UpdateCurrentPageIndex(currentPage - 1));

      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Select your category!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuestionsLoaded) {
              final indexSet = state.pageIndexes;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your exercise will be curated according to the category that you have selected.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (state.questions.length / 3).ceil(),
                        (index) {
                          bool activeIndex = indexSet.contains(index + 1);

                          return TimelineIndicator(
                            index: index,
                            isActive: activeIndex,
                            isFirst: index == 0,
                            isLast: (state.questions.length / 3).ceil() ==
                                index + 1,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: (state.questions.length / 3).ceil(),
                      onPageChanged: (index) {
                        context
                            .read<QuestionBloc>()
                            .add(ChangeOpenSection(index));
                      },
                      itemBuilder: (context, index) {
                        final startIndex = index * 3;
                        final endIndex =
                            (index * 3 + 3).clamp(0, state.questions.length);
                        final pageQuestions =
                            state.questions.sublist(startIndex, endIndex);

                        return Column(
                          children: [
                            Expanded(
                              child: AccordionWidget(
                                pageIndex: index + 1,
                                questions: pageQuestions,
                                selectedAnswers: state.selectedAnswers,
                                pageController: _pageController,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NavigationButtons(
                      pageController: _pageController,
                      handlePreviousPage: _handlePreviousPage,
                      handleAnswerSelection: _handleAnswerSelection,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Failed to load questions'));
            }
          },
        ),
      ),
    );
  }
}
