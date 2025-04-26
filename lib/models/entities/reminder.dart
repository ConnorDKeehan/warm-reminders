class Reminder {
  final int id;
  final int loginId;
  final String reminderText;
  final String? category;
  final DateTime dateCreatedUtc;
  final DateTime? dateLastShownUtc;
  final int amountOfTimesShown;
  final int importance;

  Reminder({
    required this.id,
    required this.loginId,
    required this.reminderText,
    this.category,
    required this.dateCreatedUtc,
    this.dateLastShownUtc,
    required this.amountOfTimesShown,
    required this.importance
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      loginId: json['loginId'],
      reminderText: json['reminderText'],
      category: json['category'],
      dateCreatedUtc: DateTime.parse(json['dateCreatedUtc']),
      dateLastShownUtc: json['dateLastShownUtc'] != null
          ? DateTime.parse(json['dateLastShownUtc'])
          : null,
      amountOfTimesShown: json['amountOfTimesShown'],
      importance: json['importance']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'reminderText': reminderText,
      'category': category,
      'dateCreatedUtc': dateCreatedUtc.toIso8601String(),
      'dateLastShownUtc': dateLastShownUtc?.toIso8601String(),
      'amountOfTimesShown': amountOfTimesShown,
      'importance': importance
    };
  }
}



