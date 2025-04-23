class PatchReminderRequest {
  final String reminderText;
  final String category;

  PatchReminderRequest({
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