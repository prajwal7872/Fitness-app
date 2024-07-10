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
              child: BlocBuilder<QuestionBloc, QuestionState>(
                builder: (context, state) {
                  if (state is QuestionsLoaded) {
                    final indexSet = state.pageIndexes;
                    print('indexSet $indexSet');

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          (state.questions.length / 3).ceil(), (index) {
                        // print('inside timeline $index');

                        bool activeIndex = indexSet.contains(index + 1);
                        // print('accept $activeIndex');

                        return SizedBox(
                          // width: 44,
                          child: TimelineTile(
                            axis: TimelineAxis.horizontal,
                            alignment: TimelineAlign.center,
                            isFirst: index == 0 ? true : false,
                            isLast:
                                (state.questions.length / 3).ceil() == index + 1
                                    ? true
                                    : false,
                            indicatorStyle: IndicatorStyle(
                              // width: 23.w,
                              // height: 23.h,
                              drawGap: true,
                              // padding: EdgeInsets.all(1),
                              color: Colors.white,
                              iconStyle: IconStyle(
                                fontSize: 22,
                                iconData: activeIndex
                                    ? Icons.check_circle
                                    : Icons.circle,
                                color:
                                    activeIndex ? Colors.green : Colors.black,
                              ),
                            ),
                            beforeLineStyle: LineStyle(
                              color: activeIndex ? Colors.green : Colors.black,
                              thickness: 3,
                            ),
                            afterLineStyle: LineStyle(
                              color: activeIndex ? Colors.green : Colors.black,
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
                        print('insidee onpage change $index');

                        context
                            .read<QuestionBloc>()
                            .add(ChangeOpenSection(index = 0));
                      },
                      itemBuilder: (context, index) {
                        final startIndex = index * 3;
                        final endIndex =
                            (index * 3 + 3).clamp(0, state.questions.length);
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
