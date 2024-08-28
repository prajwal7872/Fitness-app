class User {
  final String email;
  final String password;
  final String fullName;
  final String contactNo;
  final DateTime dateOfBirth;
  final Questionnaire questionnaire;

  User({
    required this.email,
    required this.password,
    required this.fullName,
    required this.contactNo,
    required this.dateOfBirth,
    required this.questionnaire,
  });
}

class Questionnaire {
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

  Questionnaire({
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
}
