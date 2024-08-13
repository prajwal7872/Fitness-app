// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/mealplan/bloc/meal_bloc.dart';
import 'package:loginpage/mealplan/bloc/meal_event.dart';
import 'package:loginpage/mealplan/bloc/meal_state.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MealBloc>().add(LoadStatusDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
              size: 40,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state is MealInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MealPlanLoaded) {
              final statusData = state.statusData;
              final selectedMealIndex = state.selectedMealIndex;
              final selectedMeal = statusData[selectedMealIndex];
              final acceptedMeals = state.acceptedMeals;
              final rejectedMeals = state.rejectedMeals;
              final showAcceptButton = state.showAcceptButton;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meal plan for Moses!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(2500 Calorie today)',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  const Text(
                    'Sorted according to your exercises',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: statusData.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> meal = entry.value;
                      return MealItem(
                        imagePath: meal['image'],
                        mealName: meal['statusLabel'],
                        mealIndex: index,
                      );
                    }).toList(),
                  ),
                  HorizontalTimeline(
                    acceptedMeals: acceptedMeals,
                    rejectedMeals: rejectedMeals,
                  ),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedMeal['mealDescription'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            NutritionalTable(
                              nutritionalPlan: selectedMeal['nutritionalPlan'],
                            ),
                            const SizedBox(height: 10),
                            if (showAcceptButton)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.blue,
                                      onPressed: () {
                                        context.read<MealBloc>().add(
                                            AcceptMealEvent(
                                                state.selectedBottleIndex));
                                      },
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 80,
                                    child: FloatingActionButton(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 72, 59),
                                      onPressed: () {
                                        context
                                            .read<MealBloc>()
                                            .add(RejectMealEvent());
                                      },
                                      child: const Text(
                                        'Reject',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (state.updateMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  state.updateMessage,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 20),
                  LunchCountdownWithRecipe(
                    imagePath: selectedMeal['image'],
                    mealName: selectedMeal['statusLabel'],
                    recipeLink: selectedMeal['recipeLink'],
                    waterCount: selectedMeal['waterCount'],
                  ),
                  const SizedBox(height: 20),
                  const BottleList()
                ],
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}

class HorizontalTimeline extends StatelessWidget {
  final List<bool> acceptedMeals;
  final List<bool> rejectedMeals;

  const HorizontalTimeline(
      {super.key, required this.acceptedMeals, required this.rejectedMeals});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(acceptedMeals.length, (index) {
          bool isFirst = index == 0;
          bool isLast = index == acceptedMeals.length - 1;
          bool isAccepted = acceptedMeals[index];
          bool isRejected = rejectedMeals[index];
          IconData iconData;
          Color iconColor;
          if (isAccepted) {
            iconData = Icons.check_circle;
            iconColor = Colors.green;
          } else if (isRejected) {
            iconData = Icons.cancel;
            iconColor = Colors.red;
          } else {
            iconData = Icons.circle;
            iconColor = Colors.black;
          }

          return SizedBox(
            width: 103,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: isFirst,
              isLast: isLast,
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                color: Colors.white,
                iconStyle: IconStyle(
                  fontSize: 22,
                  iconData: iconData,
                  color: iconColor,
                ),
              ),
              beforeLineStyle: LineStyle(
                  color: isAccepted || isRejected ? iconColor : Colors.black,
                  thickness: 3),
              afterLineStyle: LineStyle(
                  color: isAccepted || isRejected ? iconColor : Colors.black,
                  thickness: 3),
            ),
          );
        }),
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final String imagePath;
  final String mealName;
  final int mealIndex;

  const MealItem({
    super.key,
    required this.imagePath,
    required this.mealName,
    required this.mealIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MealBloc>().add(ShowMealDescriptionEvent(mealIndex));
      },
      child: Column(
        children: [
          Text(
            mealName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          const SizedBox(height: 10),
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionalTable extends StatelessWidget {
  final Map<String, String> nutritionalPlan;

  const NutritionalTable({super.key, required this.nutritionalPlan});

  @override
  Widget build(BuildContext context) {
    final keys = nutritionalPlan.keys.toList();
    final values = nutritionalPlan.values.toList();

    assert(keys.length == values.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(),
          children: List.generate(
            (keys.length / 2).ceil(),
            (index) {
              final keyIndex1 = index * 2;
              final keyIndex2 = keyIndex1 + 1;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      keys[keyIndex1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      values[keyIndex1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (keyIndex2 < keys.length) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        keys[keyIndex2],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        values[keyIndex2],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class LunchCountdownWithRecipe extends StatelessWidget {
  final String imagePath;
  final String mealName;
  final String recipeLink;
  final int waterCount;

  const LunchCountdownWithRecipe({
    super.key,
    required this.imagePath,
    required this.mealName,
    required this.recipeLink,
    required this.waterCount,
  });

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse(recipeLink);
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        if (state is MealPlanLoaded) {
          final remainingTime = state.remainingTime;
          final absRemainingTime = remainingTime.abs();
          final hours = absRemainingTime ~/ 3600;
          final minutes = (absRemainingTime % 3600) ~/ 60;
          final seconds = absRemainingTime % 60;

          return Center(
            child: InkWell(
              onTap: () async {
                if (!await launchUrl(url)) {
                  throw Exception('could not launch $url');
                }
              },
              child: Column(
                children: [
                  Text(
                    remainingTime.isNegative
                        ? 'Meal plan ended'
                        : '$mealName time ends in $hours hours:$minutes min:$seconds sec',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Get preparing!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 234, 205, 239),
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                imagePath,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ...List.generate(waterCount, (index) {
                              return Positioned(
                                left: 200 + index * 40,
                                bottom: 135,
                                child: SizedBox(
                                  height: 105,
                                  width: 50,
                                  child: Image.asset(
                                    'assets/images/bottle1.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check out the recipe',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '15 min\'s preparing time',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BottleList extends StatefulWidget {
  const BottleList({super.key});

  @override
  State<BottleList> createState() => _BottleListState();
}

class _BottleListState extends State<BottleList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        if (state is MealPlanLoaded) {
          return Column(
            children: [
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<MealBloc>().add(SelectBottleEvent(index));
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bottle1.jpg',
                            height: 150,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                          if (state.selectedBottleIndex >= index)
                            Positioned(
                              top: 52,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Water Intake: ${state.waterIntake} ml',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
