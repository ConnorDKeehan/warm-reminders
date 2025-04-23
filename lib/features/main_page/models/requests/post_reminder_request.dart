class PostReminderRequest {
  final String reminderText;
  final String category;

  PostReminderRequest({
    required this.reminderText,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'reminderText': reminderText,
      'category': category,
    };
  }
}