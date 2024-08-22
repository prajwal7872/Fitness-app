// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_event.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_state.dart';
import 'package:loginpage/features/meal/presentation/widgets/bottle_list.dart';
import 'package:loginpage/features/meal/presentation/widgets/lunch_countdown.dart';
import 'package:loginpage/features/meal/presentation/widgets/meal_item.dart';
import 'package:loginpage/features/meal/presentation/widgets/nutrition_table.dart';
import 'package:loginpage/features/meal/presentation/widgets/timeline.dart';

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
