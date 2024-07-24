// // ignore_for_file: avoid_print

// import 'package:bloc/bloc.dart';
// import 'package:loginpage/mealplan/bloc/meal_event.dart';
// import 'package:loginpage/mealplan/bloc/meal_state.dart';

// class MealBloc extends Bloc<MealEvent, MealState> {
//   MealBloc() : super(MealInitial()) {
//     on<LoadStatusDataEvent>((event, emit) {
//       final List<Map<String, dynamic>> statusData = [
//         {
//           "image": 'assets/images/receipe.jpg',
//           "statusLabel": "Breakfast",
//           "mealDescription": "Breakfast Meal description",
//           "nutritionalPlan": {
//             "fats": "5gm",
//             "carbs": "40gm",
//             "protein": "20gm",
//             "iron": "1gm"
//           },
//           "waterCount": 3,
//           "recipeLink": "https://flutter.dev"
//         },
//         {
//           "image": "assets/images/lunch.jpg",
//           "statusLabel": "Lunch",
//           "mealDescription": "Lunch Meal description",
//           "nutritionalPlan": {
//             "fats": "50gm",
//             "carbs": "30gm",
//             "protein": "20gm",
//             "iron": "1gm"
//           },
//           "waterCount": 1,
//           "recipeLink": "https://flutter.dev"
//         },
//         {
//           "image": "assets/images/snacks.jpg",
//           "statusLabel": "Snacks",
//           "mealDescription": "Snack Meal description",
//           "nutritionalPlan": {
//             "fats": "25gm",
//             "carbs": "20gm",
//             "protein": "20gm",
//             "iron": "1gm"
//           },
//           "waterCount": 1,
//           "recipeLink": "https://flutter.dev"
//         },
//         {
//           "image": "assets/images/dinner.jpg",
//           "statusLabel": "Dinner",
//           "mealDescription": "Dinner Meal description",
//           "nutritionalPlan": {
//             "fats": "5gm",
//             "carbs": "50gm",
//             "protein": "30gm",
//             "iron": "1gm"
//           },
//           "waterCount": 1,
//           "recipeLink": "https://flutter.dev"
//         }
//       ];
//       emit(MealPlanLoaded(
//           statusData, List<bool>.filled(statusData.length, false), 0, true, 0));
//     });

//     on<AcceptMealEvent>((event, emit) {
//       final state = this.state as MealPlanLoaded;
//       final acceptedMeals = List<bool>.from(state.acceptedMeals);
//       if (state.currentMealIndex < acceptedMeals.length) {
//         acceptedMeals[state.currentMealIndex] = true;
//       }
//       final nextMealIndex = state.currentMealIndex < state.statusData.length - 1
//           ? state.currentMealIndex + 1
//           : state.currentMealIndex;
//       emit(MealPlanLoaded(
//           state.statusData, acceptedMeals, nextMealIndex, true, nextMealIndex));
//     });

//     on<ShowMealDescriptionEvent>((event, emit) async {
//       final state = this.state as MealPlanLoaded;
//       print(' mealIndex = ${event.mealIndex}');
//       print('currentMealIndex = ${state.currentMealIndex}');

//       final showAcceptButton = event.mealIndex == state.currentMealIndex;
//       print(showAcceptButton);

//       emit(MealPlanLoaded(state.statusData, state.acceptedMeals,
//           state.currentMealIndex, showAcceptButton, event.mealIndex));

//       if (state.currentMealIndex != event.mealIndex) {
//         await Future.delayed(const Duration(seconds: 3));
//         emit(MealPlanLoaded(state.statusData, state.acceptedMeals,
//             state.currentMealIndex, true, state.currentMealIndex));
//       }
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loginpage/mealplan/bloc/meal_bloc.dart';
// import 'package:loginpage/mealplan/bloc/meal_event.dart';
// import 'package:loginpage/mealplan/bloc/meal_state.dart';
// import 'package:timeline_tile/timeline_tile.dart';

// class MealPlanScreen extends StatefulWidget {
//   const MealPlanScreen({super.key});

//   @override
//   State<MealPlanScreen> createState() => _MealPlanScreenState();
// }

// class _MealPlanScreenState extends State<MealPlanScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<MealBloc>().add(LoadStatusDataEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Meal Plan'),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.notifications_active,
//               size: 40,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocBuilder<MealBloc, MealState>(
//           builder: (context, state) {
//             if (state is MealInitial) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is MealPlanLoaded) {
//               final statusData = state.statusData;
//               final selectedMealIndex = state.selectedMealIndex;
//               final selectedMeal = statusData[selectedMealIndex];
//               final acceptedMeals = state.acceptedMeals;
//               final showAcceptButton = state.showAcceptButton;

//               print('selectedMealIndex $selectedMealIndex');

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Meal plan for Moses!',
//                         style: TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '(2500 Calorie today)',
//                         style: TextStyle(fontSize: 13),
//                       )
//                     ],
//                   ),
//                   const Text(
//                     'Sorted according to your exercises',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: statusData.asMap().entries.map((entry) {
//                       int index = entry.key;
//                       Map<String, dynamic> meal = entry.value;
//                       return MealItem(
//                         imagePath: meal['image'],
//                         mealName: meal['statusLabel'],
//                         mealIndex: index,
//                       );
//                     }).toList(),
//                   ),
//                   HorizontalTimeline(acceptedMeals: acceptedMeals),
//                   Card(
//                     elevation: 4.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectedMeal['mealDescription'],
//                             style: const TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 15),
//                           NutritionalTable(
//                             nutritionalPlan: selectedMeal['nutritionalPlan'],
//                           ),
//                           const SizedBox(height: 10),
//                           if (showAcceptButton)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   child: FloatingActionButton(
//                                     backgroundColor: Colors.blue,
//                                     onPressed: () {
//                                       context
//                                           .read<MealBloc>()
//                                           .add(AcceptMealEvent());
//                                     },
//                                     child: const Text(
//                                       'Accept',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 SizedBox(
//                                   width: 80,
//                                   child: FloatingActionButton(
//                                     backgroundColor:
//                                         const Color.fromARGB(255, 255, 72, 59),
//                                     onPressed: () {},
//                                     child: const Text(
//                                       'Reject',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const LunchCountdown(),
//                   const SizedBox(height: 20),
//                   const CheckRecipe(),
//                   const BottleList()
//                 ],
//               );
//             } else {
//               return const Center(child: Text('Something went wrong!'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class HorizontalTimeline extends StatelessWidget {
//   final List<bool> acceptedMeals;

//   const HorizontalTimeline({super.key, required this.acceptedMeals});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 70,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(acceptedMeals.length, (index) {
//           bool isFirst = index == 0;
//           bool isLast = index == acceptedMeals.length - 1;
//           bool isActive = acceptedMeals[index];

//           return SizedBox(
//             width: 103,
//             child: TimelineTile(
//               axis: TimelineAxis.horizontal,
//               alignment: TimelineAlign.center,
//               isFirst: isFirst,
//               isLast: isLast,
//               indicatorStyle: IndicatorStyle(
//                 drawGap: true,
//                 color: Colors.white,
//                 iconStyle: IconStyle(
//                     fontSize: 22,
//                     iconData: isActive ? Icons.check_circle : Icons.circle,
//                     color: isActive ? Colors.green : Colors.black),
//               ),
//               beforeLineStyle: LineStyle(
//                   color: isActive ? Colors.green : Colors.black, thickness: 3),
//               afterLineStyle: LineStyle(
//                   color: isActive ? Colors.green : Colors.black, thickness: 3),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class MealItem extends StatelessWidget {
//   final String imagePath;
//   final String mealName;
//   final int mealIndex;

//   const MealItem({
//     super.key,
//     required this.imagePath,
//     required this.mealName,
//     required this.mealIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.read<MealBloc>().add(ShowMealDescriptionEvent(mealIndex));
//       },
//       child: Column(
//         children: [
//           Text(
//             mealName,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
//           ),
//           const SizedBox(height: 10),
//           ClipOval(
//             child: Image.asset(
//               imagePath,
//               width: 90,
//               height: 90,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NutritionalTable extends StatelessWidget {
//   final Map<String, String> nutritionalPlan;

//   const NutritionalTable({super.key, required this.nutritionalPlan});

//   @override
//   Widget build(BuildContext context) {
//     final keys = nutritionalPlan.keys.toList();
//     final values = nutritionalPlan.values.toList();

//     assert(keys.length >= 4 && values.length >= 4);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Table(
//           border: TableBorder.all(),
//           children: [
//             TableRow(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(keys[0], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(values[0], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(keys[1], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(values[1], textAlign: TextAlign.center),
//                 ),
//               ],
//             ),
//             TableRow(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(keys[2], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(values[2], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(keys[3], textAlign: TextAlign.center),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(values[3], textAlign: TextAlign.center),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }