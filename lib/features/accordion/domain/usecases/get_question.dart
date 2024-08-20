import 'package:loginpage/features/accordion/domain/entites/question.dart';

class GetQuestions {
  List<Question> call() {
    return const [
      Question(
          1,
          'Do you have any Chronic health condition? (e.g, diabetes,hypertension)',
          ['Yes', 'None'],
          'chronic_health'),
      Question(
          2,
          'Do you follow any specific diet plan? (e.g, vegan,keto,gluten-free)',
          [
            'Balanced',
            'Vegan',
            'Vegetarian',
            'Keto',
            'Paleo',
            'Gluten-free',
            'Low-carb'
          ],
          'diet_plan'),
      Question(3, 'What is your Fitness Goal?',
          ['Lose Weight', 'Gain Weight', 'Stay Same'], 'fitness_goal'),
      Question(
          4,
          'What type of physical activities do you typically engage in?',
          ['Walking', 'Running', 'Cycling', 'Swimming', 'Weight Training'],
          'physical_activities'),
      Question(5, 'What is your Occupation?',
          ['Student', 'It Oficer', 'Teacher'], 'occupation'),
      Question(6, 'How much do you sleep in night?',
          ['4-5 hours', '6-8hours', 'more than 10hours'], "sleep"),
      Question(7, 'What is your fitness Level?',
          ['Advance', 'Intermediate', 'Basic'], 'fitnesslevel'),
      Question(8, 'How much is your Weight?', ['Below 50', '60-80 ', '80-110'],
          'weight'),
      Question(9, 'How much is your Height (in meter)',
          ['150', '160-180', '180-220'], 'height'),
      Question(10, 'What is your Gender?', ['Male', 'Female'], 'gender'),
      Question(
          11,
          'Please give us your progress feedback!',
          ['None', 'little progress', 'little progresss!'],
          'progress_feedback'),
      Question(
          12,
          'Do you have any chrinoc health condition? (e.g Diabetes,hypertension)',
          ['Yes', 'Nones'],
          'health_condition'),
    ];
  }
}
