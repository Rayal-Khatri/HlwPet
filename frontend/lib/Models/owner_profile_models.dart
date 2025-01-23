class PetOwnerProfile {
  final User user;
  final List<Pet> pets;
  final String bio;
  final String photo;

  PetOwnerProfile({
    required this.user,
    required this.pets,
    required this.bio,
    required this.photo,
  });

  factory PetOwnerProfile.fromJson(Map<String, dynamic> json) {
    final List<dynamic> petsJson = json['pets'] ?? [];
    final List<Pet> petsList =
        petsJson.map((petJson) => Pet.fromJson(petJson)).toList();

    return PetOwnerProfile(
      user: User.fromJson(json['user'] ?? {}),
      pets: petsList,
      bio: json['bio'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

class User {
  final int id;
  final String username;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '0',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int? age;
  final String? petphoto;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    this.age,
    this.petphoto,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '0',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? '0',
      petphoto: json['petphoto'] ?? '',
    );
  }
}

class UpdateUser {
  final String firstName;
  final String lastName;

  UpdateUser({
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

class UpdateProfile {
  final String bio;
  final UpdateUser user;

  UpdateProfile({
    required this.bio,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'user': user.toJson(),
    };
  }
}
