import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/mealplan/bloc/meal_bloc.dart';

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
              Icons.notifications,
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
            } else if (state is MealPlanLoaded || state is MealSelected) {
              final statusData = state is MealPlanLoaded
                  ? state.statusData
                  : (state as MealSelected).statusData;
              final selectedMeal = state is MealPlanLoaded
                  ? state.statusData[0]
                  : (state as MealSelected).selectedMeal;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal plan for Moses!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Sorted according to your exercises',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: statusData.map((meal) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<MealBloc>()
                              .add(SelectMealEvent(meal, statusData));
                        },
                        child: MealItem(
                          imagePath: meal['image'],
                          mealName: meal['statusLabel'],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 80),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue,
                                  onPressed: () {},
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 72, 59),
                                  onPressed: () {},
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const LunchCountdown(),
                  const SizedBox(height: 20),
                  const CheckRecipe(),
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

class MealItem extends StatelessWidget {
  final String imagePath;
  final String mealName;

  const MealItem({super.key, required this.imagePath, required this.mealName});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class LunchCountdown extends StatelessWidget {
  const LunchCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Lunch time starts in 30 mins',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          Text(
            'Get preparing!',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class CheckRecipe extends StatelessWidget {
  const CheckRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/receipe.jpg',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check out the recipe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '15min\'s preparing time',
                style: TextStyle(fontSize: 16),
              ),
            ],
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

    assert(keys.length >= 4 && values.length >= 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(keys[0], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(values[0], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(keys[1], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(values[1], textAlign: TextAlign.center),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(keys[2], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(values[2], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(keys[3], textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(values[3], textAlign: TextAlign.center),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
