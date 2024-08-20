import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/mealplan/bloc/meal_bloc.dart';
import 'package:loginpage/features/mealplan/bloc/meal_event.dart';

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
