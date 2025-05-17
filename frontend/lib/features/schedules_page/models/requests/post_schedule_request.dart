class PostScheduleRequest {
  final DateTime nextNotificationTimeUtc;
  final int intervalHours;

  PostScheduleRequest({
    required this.nextNotificationTimeUtc,
    required this.intervalHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'nextNotificationTimeUtc': nextNotificationTimeUtc.toIso8601String(),
      'intervalHours': intervalHours,
    };
  }
}