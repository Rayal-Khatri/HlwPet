class Adoption {
  int? _totalSize;
  int? _offset;
  late List<Dogs>? _dogs;
  List<Dogs>? get dogs => _dogs;

  Adoption({required totalSize, required offset, required List<Dogs>? dogs}) {
    if (totalSize != null) {
      _totalSize = totalSize;
    }
    if (offset != null) {
      _offset = offset;
    }
    _dogs = dogs;
  }

  int? get totalSize => _totalSize;
  set totalSize(int? totalSize) => _totalSize = totalSize;
  int? get offset => _offset;
  set offset(int? offset) => _offset = offset;
  set dogs(List<Dogs>? dogs) => _dogs = dogs;

  Adoption.fromJson(Map<String, dynamic> json) {
    _totalSize = json['totalSize'];
    _offset = json['offset'];
    if (json['dogs'] != null) {
      _dogs = <Dogs>[];
      json['dogs'].forEach((v) {
        _dogs!.add(Dogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSize'] = _totalSize;
    data['offset'] = _offset;
    if (_dogs != null) {
      data['dogs'] = _dogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dogs {
  String? _name;
  String? _shelter;
  String? _breed;
  String? _img;
  String? _size;
  int? _age;
  String? _personality;
  HealthStatus? _healthStatus;
  String? _history;
  Training? _training;
  Requirements? _requirements;

  Dogs(
      {String? name,
      String? shelter,
      String? breed,
      String? img,
      String? size,
      int? age,
      String? personality,
      HealthStatus? healthStatus,
      String? history,
      Training? training,
      Requirements? requirements}) {
    if (name != null) {
      _name = name;
    }
    if (shelter != null) {
      _shelter = shelter;
    }
    if (breed != null) {
      _breed = breed;
    }
    if (img != null) {
      _img = img;
    }
    if (size != null) {
      _size = size;
    }
    if (age != null) {
      _age = age;
    }
    if (personality != null) {
      _personality = personality;
    }
    if (healthStatus != null) {
      _healthStatus = healthStatus;
    }
    if (history != null) {
      _history = history;
    }
    if (training != null) {
      _training = training;
    }
    if (requirements != null) {
      _requirements = requirements;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  String? get shelter => _shelter;
  set shelter(String? shelter) => _shelter = shelter;
  String? get breed => _breed;
  set breed(String? breed) => _breed = breed;
  String? get img => _img;
  set img(String? img) => _img = img;
  String? get size => _size;
  set size(String? size) => _size = size;
  int? get age => _age;
  set age(int? age) => _age = age;
  String? get personality => _personality;
  set personality(String? personality) => _personality = personality;
  HealthStatus? get healthStatus => _healthStatus;
  set healthStatus(HealthStatus? healthStatus) => _healthStatus = healthStatus;
  String? get history => _history;
  set history(String? history) => _history = history;
  Training? get training => _training;
  set training(Training? training) => _training = training;
  Requirements? get requirements => _requirements;
  set requirements(Requirements? requirements) => _requirements = requirements;

  Dogs.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _shelter = json['shelter'];
    _breed = json['breed'];
    _img = json['img'];
    _size = json['size'];
    _age = json['age'];
    _personality = json['personality'];
    _healthStatus = json['health_status'] != null
        ? HealthStatus.fromJson(json['health_status'])
        : null;
    _history = json['history'];
    _training = json['training'] != null
        ? Training.fromJson(json['training'])
        : null;
    _requirements = json['requirements'] != null
        ? Requirements.fromJson(json['requirements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['shelter'] = _shelter;
    data['breed'] = _breed;
    data['img'] = _img;
    data['size'] = _size;
    data['age'] = _age;
    data['personality'] = _personality;
    if (_healthStatus != null) {
      data['health_status'] = _healthStatus!.toJson();
    }
    data['history'] = _history;
    if (_training != null) {
      data['training'] = _training!.toJson();
    }
    if (_requirements != null) {
      data['requirements'] = _requirements!.toJson();
    }
    return data;
  }
}

class HealthStatus {
  List<String>? _vaccinations;
  bool? _neutered;
  String? _medicalIssues;

  HealthStatus(
      {List<String>? vaccinations, bool? neutered, String? medicalIssues}) {
    if (vaccinations != null) {
      _vaccinations = vaccinations;
    }
    if (neutered != null) {
      _neutered = neutered;
    }
    if (medicalIssues != null) {
      _medicalIssues = medicalIssues;
    }
  }

  List<String>? get vaccinations => _vaccinations;
  set vaccinations(List<String>? vaccinations) => _vaccinations = vaccinations;
  bool? get neutered => _neutered;
  set neutered(bool? neutered) => _neutered = neutered;
  String? get medicalIssues => _medicalIssues;
  set medicalIssues(String? medicalIssues) => _medicalIssues = medicalIssues;

  HealthStatus.fromJson(Map<String, dynamic> json) {
    _vaccinations = json['vaccinations'].cast<String>();
    _neutered = json['neutered'];
    _medicalIssues = json['medical_issues'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vaccinations'] = _vaccinations;
    data['neutered'] = _neutered;
    data['medical_issues'] = _medicalIssues;
    return data;
  }
}

class Training {
  String? _obedience;
  String? _behavior;

  Training({String? obedience, String? behavior}) {
    if (obedience != null) {
      _obedience = obedience;
    }
    if (behavior != null) {
      _behavior = behavior;
    }
  }

  String? get obedience => _obedience;
  set obedience(String? obedience) => _obedience = obedience;
  String? get behavior => _behavior;
  set behavior(String? behavior) => _behavior = behavior;

  Training.fromJson(Map<String, dynamic> json) {
    _obedience = json['obedience'];
    _behavior = json['behavior'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['obedience'] = _obedience;
    data['behavior'] = _behavior;
    return data;
  }
}

class Requirements {
  String? _idealHome;
  String? _exerciseNeeds;

  Requirements({String? idealHome, String? exerciseNeeds}) {
    if (idealHome != null) {
      _idealHome = idealHome;
    }
    if (exerciseNeeds != null) {
      _exerciseNeeds = exerciseNeeds;
    }
  }

  String? get idealHome => _idealHome;
  set idealHome(String? idealHome) => _idealHome = idealHome;
  String? get exerciseNeeds => _exerciseNeeds;
  set exerciseNeeds(String? exerciseNeeds) => _exerciseNeeds = exerciseNeeds;

  Requirements.fromJson(Map<String, dynamic> json) {
    _idealHome = json['ideal_home'];
    _exerciseNeeds = json['exercise_needs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ideal_home'] = _idealHome;
    data['exercise_needs'] = _exerciseNeeds;
    return data;
  }
}
