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
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: List.generate(
                  9,
                  (index) => SizedBox(
                    width: 44,
                    child: TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.center,
                      beforeLineStyle:
                          const LineStyle(color: Colors.black, thickness: 2),
                      isFirst: index == 0,
                      isLast: index == 8,
                      indicatorStyle: IndicatorStyle(
                        width: 24,
                        height: 24,
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(0),
                        indicator: Container(
                          decoration: BoxDecoration(
                            color: index < _currentIndex
                                ? Colors.black
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: index < _currentIndex
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      itemCount: (state.questions.length / 6).ceil(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final startIndex = index * 6;
                        final endIndex =
                            (index * 6 + 6).clamp(0, state.questions.length);
                        final pageQuestions =
                            state.questions.sublist(startIndex, endIndex);

                        return AccordionWidget(
                          questions: pageQuestions,
                          selectedAnswers: state.selectedAnswers,
                          onChanged: (entry) {
                            context.read<QuestionBloc>().add(
                                  AnswerSelected(
                                      entry.key + startIndex, entry.value!),
                                );
                          },
                          pageController: _pageController,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Something went wrong!'));
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
