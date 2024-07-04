import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_event.dart';
import 'package:loginpage/calorie/bloc/calorie_state.dart';
import 'package:loginpage/calorie/widgets/calorie_chart.dart';

class HealthDataPage extends StatefulWidget {
  const HealthDataPage({super.key});

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CalorieBloc>(context).add(FetchWeeklyCalorieData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Active Energy Burned Data'),
      ),
      body: BlocBuilder<CalorieBloc, CalorieState>(
        builder: (context, state) {
          if (state is CalorieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CalorieLoaded) {
            return CalorieChart(state.weeklyCalorieData);
          } else if (state is CalorieError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
