import 'package:loginpage/features/Signup/domain/entites/userdetails.dart';

class UserModel {
  final String email;
  final String password;
  final String fullName;
  final String contactNo;
  final String dateOfBirth;
  final QuestionnaireModel questionnaire;

  UserModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.contactNo,
    required this.dateOfBirth,
    required this.questionnaire,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'contact_no': contactNo,
      'date_of_birth': dateOfBirth,
      'questionnaire': questionnaire.toJson(),
    };
  }

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      fullName: json['full_name'],
      contactNo: json['contact_no'],
      dateOfBirth: json['date_of_birth'],
      questionnaire: QuestionnaireModel.fromJson(json['questionnaire']),
    );
  }

  // Convert UserModel to User entity
  User toEntity() {
    return User(
      email: email,
      password: password,
      fullName: fullName,
      contactNo: contactNo,
      dateOfBirth: DateTime.parse(dateOfBirth),
      questionnaire: questionnaire.toEntity(),
    );
  }

  // Convert User entity to UserModel
  factory UserModel.fromEntity(User user) {
    return UserModel(
      email: user.email,
      password: user.password,
      fullName: user.fullName,
      contactNo: user.contactNo,
      dateOfBirth: user.dateOfBirth.toIso8601String(),
      questionnaire: QuestionnaireModel.fromEntity(user.questionnaire),
    );
  }
}

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

  // Convert QuestionnaireModel to JSON
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

  // Convert JSON to QuestionnaireModel
  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      chronicHealth: json['chronic_health'],
      dietPlan: json['diet_plan'],
      fitnessGoal: json['fitness_goal'],
      physicalActivities: json['physical_activities'],
      occupation: json['occupation'],
      sleep: json['sleep'],
      fitnessLevel: json['fitness_level'],
      weight: json['weight'],
      height: json['height'],
      gender: json['gender'],
      progressFeedback: json['progress_feedback'],
      healthCondition: json['health_condition'],
    );
  }

  // Convert QuestionnaireModel to Questionnaire entity
  Questionnaire toEntity() {
    return Questionnaire(
      chronicHealth: chronicHealth,
      dietPlan: dietPlan,
      fitnessGoal: fitnessGoal,
      physicalActivities: physicalActivities,
      occupation: occupation,
      sleep: sleep,
      fitnessLevel: fitnessLevel,
      weight: weight,
      height: height,
      gender: gender,
      progressFeedback: progressFeedback,
      healthCondition: healthCondition,
    );
  }

  // Convert Questionnaire entity to QuestionnaireModel
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
}
