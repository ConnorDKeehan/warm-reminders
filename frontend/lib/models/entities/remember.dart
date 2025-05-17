class Remember {
  final int id;
  final int loginId;
  final String title;
  final String? description;
  final DateTime dateCreatedUtc;

  Remember({
    required this.id,
    required this.loginId,
    required this.title,
    this.description,
    required this.dateCreatedUtc
  });

  factory Remember.fromJson(Map<String, dynamic> json) {
    return Remember(
        id: json['id'],
        loginId: json['loginId'],
        title: json['title'],
        description: json['description'],
        dateCreatedUtc: DateTime.parse(json['dateCreatedUtc'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'title': title,
      'description': description,
      'dateCreatedUtc': dateCreatedUtc.toIso8601String()
    };
  }
}



