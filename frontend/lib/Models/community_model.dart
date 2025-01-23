class CommunityDetail {
  final int id;
  final String name;
  final String description;
  final String creationDate;
  final String coverPhoto;
  final List<int> members;

  CommunityDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.coverPhoto,
    required this.members,
  });

  factory CommunityDetail.fromJson(Map<String, dynamic> json) {
    return CommunityDetail(
      id: json['id'],
      name: json['community_name'],
      description: json['description'],
      creationDate: json['creation_date'],
      coverPhoto: json['cover_photo'] ?? '',
      members: List<int>.from(json['members']),
    );
  }
}
