import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/mealplan/bloc/meal_bloc.dart';
import 'package:loginpage/features/mealplan/bloc/meal_state.dart';
import 'package:url_launcher/url_launcher.dart';

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
