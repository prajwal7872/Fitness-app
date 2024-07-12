import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/question_state.dart';
import 'package:loginpage/sign_up/bloc/questionn_bloc.dart';
import 'package:loginpage/sign_up/widgets/accordion_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();

  void _handleAnswerSelection(BuildContext context) {
    final state = context.read<QuestionBloc>().state;

    if (state is QuestionsLoaded) {
      final updatedAnswers = Map<int, String?>.from(state.selectedAnswers);

      // Calculate the start and end index of the current page
      final currentPage = _pageController.page!.toInt();
      final startIndex = currentPage * 3;
      final endIndex = (currentPage * 3 + 3).clamp(0, state.questions.length);

      // Check if all questions on the current page are answered
      bool allQuestionsOnCurrentPageAnswered = true;
      for (int i = startIndex; i < endIndex; i++) {
        if (updatedAnswers[state.questions[i].id] == null) {
          allQuestionsOnCurrentPageAnswered = false;
          break;
        }
      }

      // If all questions on the current page are answered, navigate to the next page
      if (allQuestionsOnCurrentPageAnswered) {
        context.read<QuestionBloc>().add(ChangeOpenSection(currentPage + 1));
        context.read<QuestionBloc>().add(SetPageIndex(currentPage + 1));
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _showValidationDialog(context);
      }
    }
  }

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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                  child: BlocBuilder<QuestionBloc, QuestionState>(
                    builder: (context, state) {
                      if (state is QuestionsLoaded) {
                        final indexSet = state.pageIndexes;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              (state.questions.length / 3).ceil(), (index) {
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
                                  color:
                                      activeIndex ? Colors.green : Colors.black,
                                  thickness: 3,
                                ),
                                afterLineStyle: LineStyle(
                                  color:
                                      activeIndex ? Colors.green : Colors.black,
                                  thickness: 3,
                                ),
                              ),
                            );
                          }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<QuestionBloc, QuestionState>(
                    builder: (context, state) {
                      if (state is QuestionsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is QuestionsLoaded) {
                        return PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemCount: (state.questions.length / 3).ceil(),
                          onPageChanged: (index) {
                            context
                                .read<QuestionBloc>()
                                .add(ChangeOpenSection(index = 0));
                            context
                                .read<QuestionBloc>()
                                .add(CheckAnswers(index));
                          },
                          itemBuilder: (context, index) {
                            final startIndex = index * 3;
                            final endIndex = (index * 3 + 3)
                                .clamp(0, state.questions.length);
                            final pageQuestions =
                                state.questions.sublist(startIndex, endIndex);

                            return AccordionWidget(
                              pageIndex: index + 1,
                              questions: pageQuestions,
                              selectedAnswers: state.selectedAnswers,
                              pageController: _pageController,
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('Failed to load questions'));
                      }
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: BlocBuilder<QuestionBloc, QuestionState>(
                builder: (context, state) {
                  if (state is QuestionsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 80,
                        child: FloatingActionButton(
                          backgroundColor: state.allQuestionsAnswered
                              ? Colors.green
                              : Colors.grey,
                          onPressed: () {
                            _handleAnswerSelection(context);
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
