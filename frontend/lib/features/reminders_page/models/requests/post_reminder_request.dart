class PostReminderRequest {
  final String reminderText;
  final String category;
  final int importance;

  PostReminderRequest({
    required this.reminderText,
    required this.category,
    required this.importance
  });

  Map<String, dynamic> toJson() {
    return {
      'reminderText': reminderText,
      'category': category,
      'importance': importance
    };
  }
}