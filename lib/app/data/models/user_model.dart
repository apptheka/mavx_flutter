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
    final dynamic statusValue = json['status'];
    final int parsedStatus = statusValue is int
        ? statusValue
        : int.tryParse(statusValue?.toString() ?? '') ?? 0;

    final String parsedMessage = json['message']?.toString() ?? '';
    final String parsedToken = json['token']?.toString() ?? '';

    UserData parsedData;
    final dynamic rawData = json['data'];

    if (parsedStatus == 200 && rawData is Map<String, dynamic>) {
      // Successful response with user payload
      parsedData = UserData.fromJson(rawData);
    } else {
      // Error or unexpected payload shape – use a safe empty model
      parsedData = UserData.empty();
    }

    return UserModel(
      status: parsedStatus,
      message: parsedMessage,
      token: parsedToken,
      data: parsedData,
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
  final String skills_csv;
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
    required this.skills_csv,
    required this.primarySector,

    required this.primaryFunction,
    required this.status,
  });

  UserData.empty()
      : id = 0,
        fullName = '',
        email = '',
        phone = '',
        resume = '',
        ctc = '',
        profile = '',
        roleType = '',
        primarySector = 0,
        primaryFunction = 0,
        skills_csv = '',
        status = '';

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      resume: json['resume']?.toString() ?? '',
      ctc: json['ctc']?.toString() ?? '',
      profile: json['profile']?.toString() ?? '',
      roleType: json['roleType']?.toString() ?? '',
      primarySector: json['primarySector'] is int
          ? json['primarySector'] as int
          : int.tryParse(json['primarySector']?.toString() ?? '') ?? 0,
      primaryFunction: json['primaryFunction'] is int
          ? json['primaryFunction'] as int
          : int.tryParse(json['primaryFunction']?.toString() ?? '') ?? 0,
      skills_csv: json['skills_csv']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
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
      'skills_csv': skills_csv,
      'status': status,
    };
  }
}
