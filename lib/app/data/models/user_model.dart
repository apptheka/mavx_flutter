class UserModel {
  final int status;
  final String message;
  final String token;
  final UserData data;

  UserModel({
    required this.status,
    required this.message,
    required this.token,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String resume;
  final String ctc;
  final String profile;
  final String roleType;
  final int primarySector;
  final int primaryFunction;
  final String status;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.resume,
    required this.ctc,
    required this.profile,
    required this.roleType,
    required this.primarySector,
    required this.primaryFunction,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      resume: json['resume'],
      ctc: json['ctc'],
      profile: json['profile'],
      roleType: json['roleType'],
      primarySector: json['primarySector'],
      primaryFunction: json['primaryFunction'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'resume': resume,
      'ctc': ctc,
      'profile': profile,
      'roleType': roleType,
      'primarySector': primarySector,
      'primaryFunction': primaryFunction,
      'status': status,
    };
  }
}
