class UserDetails {
  final String email;
  final String password;
  final String fullName;
  final String contactNo;
  final String dateOfBirth;
  final List<Questionnaire> questionnaire;

  UserDetails({
    required this.email,
    required this.password,
    required this.fullName,
    required this.contactNo,
    required this.dateOfBirth,
    required this.questionnaire,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'contact_no': contactNo,
      'date_of_birth': dateOfBirth,
      'questionnaire': questionnaire.map((q) => q.toJson()).toList(),
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'chronic_health': chronicHealth,
      'diet_plan': dietPlan,
      'fitness_goal': fitnessGoal,
      'physical_activities': physicalActivities,
      'occupation': occupation,
      'sleep': sleep,
      'fitnesslevel': fitnessLevel,
      'weight': weight,
      'height': height,
      'gender': gender,
      'progress_feedback': progressFeedback,
      'health_condition': healthCondition,
    };
  }
}
