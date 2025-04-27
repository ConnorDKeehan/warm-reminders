class PostRememberRequest {
  final String title;
  final String? description;

  PostRememberRequest({
    required this.title,
    required this.description
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description
    };
  }
}