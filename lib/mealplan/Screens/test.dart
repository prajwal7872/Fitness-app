// part of 'meal_bloc.dart';

// sealed class MealEvent extends Equatable {
//   const MealEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadStatusDataEvent extends MealEvent {}

// class SelectMealEvent extends MealEvent {
//   final Map<String, dynamic> selectedMeal;
//   final List<Map<String, dynamic>> statusData;
//   final int selectedIndex;

//   const SelectMealEvent(this.selectedMeal, this.statusData, this.selectedIndex);

//   @override
//   List<Object> get props => [selectedMeal, statusData, selectedIndex];
// }

// class AcceptMealEvent extends MealEvent {
//   final int index;

//   const AcceptMealEvent(this.index);

//   @override
//   List<Object> get props => [index];
// }
// part of 'meal_bloc.dart';

// sealed class MealState extends Equatable {
//   const MealState();

//   @override
//   List<Object> get props => [];
// }

// final class MealInitial extends MealState {}

// class MealPlanLoaded extends MealState {
//   final List<Map<String, dynamic>> statusData;
//   final List<bool> acceptedMeals;

//   const MealPlanLoaded(this.statusData, this.acceptedMeals);

//   @override
//   List<Object> get props => [statusData, acceptedMeals];
// }

// class MealSelected extends MealState {
//   final List<Map<String, dynamic>> statusData;
//   final Map<String, dynamic> selectedMeal;
//   final List<bool> acceptedMeals;
//   final int selectedIndex;

//   const MealSelected(
//       this.selectedMeal, this.statusData, this.acceptedMeals, this.selectedIndex);

//   @override
//   List<Object> get props => [selectedMeal, statusData, acceptedMeals, selectedIndex];
// }

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'meal_event.dart';
// part 'meal_state.dart';

// class MealBloc extends Bloc<MealEvent, MealState> {
//   MealBloc() : super(MealInitial()) {
//     on<LoadStatusDataEvent>((event, emit) {
//       final List<Map<String, dynamic>> statusData = [
//         {
//           "image": "assets/images/breakfast.jpeg",
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
//       emit(MealPlanLoaded(statusData, List.filled(statusData.length, false)));
//     });

//     on<SelectMealEvent>((event, emit) {
//       final currentState = state;
//       if (currentState is MealPlanLoaded || currentState is MealSelected) {
//         emit(MealSelected(
//           event.selectedMeal,
//           event.statusData,
//           currentState is MealPlanLoaded
//               ? currentState.acceptedMeals
//               : (currentState as MealSelected).acceptedMeals,
//           event.selectedIndex,
//         ));
//       }
//     });

//     on<AcceptMealEvent>((event, emit) {
//       final currentState = state;
//       if (currentState is MealPlanLoaded || currentState is MealSelected) {
//         final acceptedMeals = List<bool>.from(
//             currentState is MealPlanLoaded
//                 ? currentState.acceptedMeals
//                 : (currentState as MealSelected).acceptedMeals);
//         acceptedMeals[event.index] = true;

//         if (currentState is MealPlanLoaded) {
//           emit(MealPlanLoaded(currentState.statusData, acceptedMeals));
//         } else if (currentState is MealSelected) {
//           emit(MealSelected(currentState.selectedMeal,
//               currentState.statusData, acceptedMeals, currentState.selectedIndex));
//         }
//       }
//     });
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loginpage/mealplan/bloc/meal_bloc.dart';
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
//             } else if (state is MealPlanLoaded || state is MealSelected) {
//               final statusData = state is MealPlanLoaded
//                   ? state.statusData
//                   : (state as MealSelected).statusData;
//               final selectedMeal = state is MealPlanLoaded
//                   ? state.statusData[0]
//                   : (state as MealSelected).selectedMeal;
//               final acceptedMeals = state is MealPlanLoaded
//                   ? state.acceptedMeals
//                   : (state as MealSelected).acceptedMeals;
//               final selectedIndex = state is MealSelected ? state.selectedIndex : 0;

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
//                     children: statusData.map((meal) {
//                       int index = statusData.indexOf(meal);
//                       return GestureDetector(
//                         onTap: () {
//                           context.read<MealBloc>().add(
//                               SelectMealEvent(meal, statusData, index));
//                         },
//                         child: MealItem(
//                           imagePath: meal['image'],
//                           mealName: meal['statusLabel'],
//                         ),
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
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: 80,
//                                 child: FloatingActionButton(
//                                   backgroundColor: Colors.blue,
//                                   onPressed: () {
//                                     context
//                                         .read<MealBloc>()
//                                         .add(AcceptMealEvent(selectedIndex));
//                                   },
//                                   child: const Text(
//                                     'Accept',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               SizedBox(
//                                 width: 80,
//                                 child: FloatingActionButton(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 255, 72, 59),
//                                   onPressed: () {},
//                                   child: const Text(
//                                     'Reject',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
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

// class MealItem extends StatelessWidget {
//   final String imagePath;
//   final String mealName;

//   const MealItem({super.key, required this.imagePath, required this.mealName});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           mealName,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
//         ),
//         const SizedBox(height: 10),
//         ClipOval(
//           child: Image.asset(
//             imagePath,
//             width: 90,
//             height: 90,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ],
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
//         children: List.generate(4, (index) {
//           bool isFirst = index == 0;
//           bool isLast = index == 3;
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
//                   fontSize: 22,
//                   iconData: isActive ? Icons.check_circle : Icons.circle,
//                   color: isActive ? Colors.green : Colors.black,
//                 ),
//               ),
//               beforeLineStyle: LineStyle(
//                 color: isActive ? Colors.green : Colors.black,
//                 thickness: 3,
//               ),
//               afterLineStyle: LineStyle(
//                 color: isActive ? Colors.green : Colors.black,
//                 thickness: 3,
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

