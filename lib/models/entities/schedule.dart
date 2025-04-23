class Schedule {
  final int id;
  final int loginId;
  final DateTime dateCreatedUtc;
  final DateTime nextNotificationTimeUtc;
  final int intervalHours;

  Schedule({
    required this.id,
    required this.loginId,
    required this.dateCreatedUtc,
    required this.nextNotificationTimeUtc,
    required this.intervalHours
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      loginId: json['loginId'],
      dateCreatedUtc: DateTime.parse(json['dateCreatedUtc']),
      nextNotificationTimeUtc: DateTime.parse(json['nextNotificationTimeUtc']+'Z'),
      intervalHours: json['intervalHours']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'dateCreatedUtc': dateCreatedUtc.toIso8601String(),
      'nextNotificationTimeUtc': nextNotificationTimeUtc.toIso8601String(),
      'intervalHours': intervalHours
    };
  }
}