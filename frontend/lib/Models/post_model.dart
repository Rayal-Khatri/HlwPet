class UserProfile {
  final int id;
  final String username;

  UserProfile({
    required this.id,
    required this.username,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      username: json['username'] as String,
    );
  }
}

class PostModel {
  final int id;
  final int communityId;
  final List<UserProfile> author;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.communityId,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var authorJson = json['author'] as Map<String, dynamic>;
    UserProfile author = UserProfile.fromJson(authorJson);

    return PostModel(
      id: json['id'] as int,
      communityId: json['community_id'] as int,
      author: [author],
      title: json['title'] as String? ?? '',
      description: json['content'] as String? ?? '',
      imageUrl: json['photo'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? ''),
    );
  }
}
