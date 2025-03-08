

class Suitable {
  String code;
  String name;

  Suitable({required this.code, required this.name, });

  Map<String, dynamic> toJson() => {'code': code, 'name': name,};

  factory Suitable.fromJson(Map<String, dynamic> json) {
    return Suitable(code: json['code'], name: json['name']);
  }
}



class Season {
  String code;
  String name;

  Season({required this.code, required this.name, });

  Map<String, dynamic> toJson() => {'code': code, 'name': name,};

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(code: json['code'], name: json['name']);
  }
}


class Translation {
  String code;
  String name;

  Translation({required this.code, required this.name, });

  Map<String, dynamic> toJson() => {'code': code, 'name': name,};

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(code: json['code'], name: json['name']);
  }
}


class Version {
  String code;
  String name;

  Version({required this.code, required this.name, });

  Map<String, dynamic> toJson() => {'code': code, 'name': name,};

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(code: json['code'], name: json['name']);
  }
}