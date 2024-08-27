import 'package:loginpage/features/accordion/domain/entites/userdetails.dart';

class QuestionnaireModel {
  final String chronicHealth;
  final String dietPlan;
  final String fitnessGoal;
  final String physicalActivities;
  final String occupation;
  final String sleep;
  final String fitnessLevel;
  final String weight;
  final String height;
  final String gender;
  final String progressFeedback;
  final String healthCondition;

  QuestionnaireModel({
    required this.chronicHealth,
    required this.dietPlan,
    required this.fitnessGoal,
    required this.physicalActivities,
    required this.occupation,
    required this.sleep,
    required this.fitnessLevel,
    required this.weight,
    required this.height,
    required this.gender,
    required this.progressFeedback,
    required this.healthCondition,
  });

  factory QuestionnaireModel.fromEntity(Questionnaire questionnaire) {
    return QuestionnaireModel(
      chronicHealth: questionnaire.chronicHealth,
      dietPlan: questionnaire.dietPlan,
      fitnessGoal: questionnaire.fitnessGoal,
      physicalActivities: questionnaire.physicalActivities,
      occupation: questionnaire.occupation,
      sleep: questionnaire.sleep,
      fitnessLevel: questionnaire.fitnessLevel,
      weight: questionnaire.weight,
      height: questionnaire.height,
      gender: questionnaire.gender,
      progressFeedback: questionnaire.progressFeedback,
      healthCondition: questionnaire.healthCondition,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chronic_health': chronicHealth,
      'diet_plan': dietPlan,
      'fitness_goal': fitnessGoal,
      'physical_activities': physicalActivities,
      'occupation': occupation,
      'sleep': sleep,
      'fitness_level': fitnessLevel,
      'weight': weight,
      'height': height,
      'gender': gender,
      'progress_feedback': progressFeedback,
      'health_condition': healthCondition,
    };
  }
}

class UserModel {
  final String email;
  final String password;
  final String fullName;
  final String contactNo;
  final DateTime dateOfBirth;
  final List<QuestionnaireModel> questionnaire;

  UserModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.contactNo,
    required this.dateOfBirth,
    required this.questionnaire,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      email: user.email,
      password: user.password,
      fullName: user.fullName,
      contactNo: user.contactNo,
      dateOfBirth: user.dateOfBirth,
      questionnaire: user.questionnaire
          .map((q) => QuestionnaireModel.fromEntity(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'contact_no': contactNo,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'questionnaire': questionnaire.map((q) => q.toJson()).toList(),
    };
  }
}
