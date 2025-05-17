class PatchScheduleRequest {
  final DateTime nextNotificationTimeUtc;
  final int intervalHours;

  PatchScheduleRequest({
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