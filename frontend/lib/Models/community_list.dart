class CommunityListModel {
  final int id;
  final String name;
  CommunityListModel({
    required this.id,
    required this.name,
  });

  factory CommunityListModel.fromJson(Map<String, dynamic> json) {
    return CommunityListModel(id: json['id'], name: json['community_name']);
  }
}
