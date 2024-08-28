import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/data/repositories/userdetails_repo_impl.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_state.dart';
import 'package:loginpage/features/accordion/presentation/services/questionnaire_helper.dart';
import 'package:loginpage/features/accordion/presentation/widgets/accordion.dart';
import 'package:loginpage/features/accordion/presentation/widgets/navigation_buttons.dart';
import 'package:loginpage/features/accordion/presentation/widgets/timeline_tile.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';

import 'package:loginpage/features/accordion/data/datasources/userdetails_remote_data_sources.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const MyHomePage({super.key, required this.userDetails});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  late QuestionnaireNavigationHelper _navigationHelper;

  @override
  void initState() {
    super.initState();

    final userDataSource = UserRemoteDataSource(client: http.Client());
    final userRepository = UserRepositoryImpl(remoteDataSource: userDataSource);
    final postUserDataUseCase = PostUserDataUseCase(repository: userRepository);

    _navigationHelper = QuestionnaireNavigationHelper(
      pageController: _pageController,
      userDetails: widget.userDetails,
      postUserDataUseCase: postUserDataUseCase,
    );
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
                            .add(ChangeOpenSection(index = 0));
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
                      handlePreviousPage: _navigationHelper.handlePreviousPage,
                      handleAnswerSelection:
                          _navigationHelper.handleAnswerSelection,
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
