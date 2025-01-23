class SearchedUser {
  final String username;
  final String firstName;
  final String lastName;

  SearchedUser({
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory SearchedUser.fromJson(Map<String, dynamic> json) {
    return SearchedUser(
      username: json['username'] ?? 'username',
      firstName: json['first_name'] ?? 'first_name',
      lastName: json['last_name'] ?? 'last_name',
    );
  }
}

class UserProfile {
  final int profileId;
  final SearchedUser user;
  final String address;

  UserProfile({
    required this.profileId,
    required this.user,
    required this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileId: json['id'] ?? 'id',
      user: SearchedUser.fromJson(json['user'] ?? {}),
      address: json['address'] ?? 'address',
    );
  }

  @override
  String toString() {
    return 'UserProfile{profileId: $profileId, user: $user, address: $address}';
  }
}
