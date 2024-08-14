// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/mealplan/Screens/meal_screen.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/question_state.dart';
import 'package:loginpage/sign_up/bloc/questionn_bloc.dart';
import 'package:loginpage/sign_up/models/question.dart';
import 'package:loginpage/sign_up/widgets/accordion_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

    storeSelectedAnswersInUser(
        updatedAnswers, state.questions, widget.userDetails);

    print(widget.userDetails);

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
        Navigator.of(context).push(MaterialPageRoute(
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

  void storeSelectedAnswersInUser(Map<int, String?> answers,
      List<Question> questions, Map<String, dynamic> userDetails) {
    Map<String, dynamic> questionnaireData = {};

    answers.forEach((questionId, answer) {
      final question = questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => const Question(0, '', [], ''),
      );
      questionnaireData[question.shortname] = answer;
    });
    if (userDetails.containsKey("questionnaire") &&
        userDetails["questionnaire"] is List) {
      if (userDetails["questionnaire"].isNotEmpty) {
        userDetails["questionnaire"]
            [0] = {...userDetails["questionnaire"][0], ...questionnaireData};
      } else {
        userDetails["questionnaire"].add(questionnaireData);
      }
    } else {
      // UserDetails["questionnaire"] = [questionnaireData];
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select your category!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your exercise will be curated according to the category that you have selected.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuestionsLoaded) {
              final indexSet = state.pageIndexes;
              final isLastPage = state.currentPageIndex >= 3;

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            (state.questions.length / 3).ceil(),
                            (index) {
                              bool activeIndex = indexSet.contains(index + 1);

                              return SizedBox(
                                child: TimelineTile(
                                  axis: TimelineAxis.horizontal,
                                  alignment: TimelineAlign.center,
                                  isFirst: index == 0,
                                  isLast: (state.questions.length / 3).ceil() ==
                                      index + 1,
                                  indicatorStyle: IndicatorStyle(
                                    drawGap: true,
                                    color: Colors.white,
                                    iconStyle: IconStyle(
                                      fontSize: 22,
                                      iconData: activeIndex
                                          ? Icons.check_circle
                                          : Icons.circle,
                                      color: activeIndex
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                  beforeLineStyle: LineStyle(
                                    color: activeIndex
                                        ? Colors.green
                                        : Colors.black,
                                    thickness: 3,
                                  ),
                                  afterLineStyle: LineStyle(
                                    color: activeIndex
                                        ? Colors.green
                                        : Colors.black,
                                    thickness: 3,
                                  ),
                                ),
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
                                .add(ChangeOpenSection(index = 0));
                          },
                          itemBuilder: (context, index) {
                            final startIndex = index * 3;
                            final endIndex = (index * 3 + 3)
                                .clamp(0, state.questions.length);
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
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 80,
                        child: FloatingActionButton(
                            heroTag: 'nextButton',
                            backgroundColor: state.allQuestionsAnswered
                                ? Colors.green
                                : Colors.grey,
                            onPressed: () {
                              _handleAnswerSelection(context, state);
                            },
                            child: isLastPage
                                ? const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    'Next',
                                    style: TextStyle(color: Colors.white),
                                  )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 80,
                        child: FloatingActionButton(
                          heroTag: 'previousButton',
                          backgroundColor: state.currentPageIndex > 0
                              ? Colors.green
                              : Colors.grey,
                          onPressed: () {
                            _handlePreviousPage(context, state);
                          },
                          child: const Text(
                            'Previous',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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
