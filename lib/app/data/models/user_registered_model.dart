class UserRegisteredModel {
  final int? id;
  final String? fullName;
  final String? lastName;
  final String? dob;
  final String? location;
  final String? country;
  final String? continent;
  final String? phone;
  final String? email;
  final String? alternateEmail;
  final int? experience;
  final String? ctc;
  final String? linkedin;
  final String? roleType;
  final int? primaryFunction;
  final String? customPrimaryFunction;
  final int? primarySector;
  final String? customPrimarySector;
  final String? employer;
  final int? secondaryFunction;
  final int? secondarySector;
  final String? achievements;
  final String? resume;
  final String? idType;
  final String? idFile;
  final String? profile;
  final String? skillsCsv; 
  final DateTime? createdAt;
  final String? password;
  final String? status;

  UserRegisteredModel({
    this.id,
    this.fullName,
    this.lastName,
    this.dob,
    this.location,
    this.country,
    this.continent,
    this.phone,
    this.email,
    this.alternateEmail,
    this.experience,
    this.ctc,
    this.linkedin,
    this.roleType,
    this.primaryFunction,
    this.customPrimaryFunction,
    this.primarySector,
    this.customPrimarySector,
    this.employer,
    this.secondaryFunction,
    this.secondarySector,
    this.achievements,
    this.resume,
    this.idType,
    this.idFile,
    this.profile,
    this.skillsCsv,  
    this.createdAt,
    this.password,
    this.status,
  });

  factory UserRegisteredModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    return UserRegisteredModel(
      id: toInt(json['id']),
      fullName: json['fullName']?.toString(),
      lastName: json['lastName']?.toString(),
      dob: json['dob']?.toString(),
      location: json['location']?.toString(),
      country: json['country']?.toString(),
      continent: json['continent']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      alternateEmail: json['alternateEmail']?.toString(),
      experience: toInt(json['experience']),
      ctc: json['ctc']?.toString(),
      linkedin: json['linkedin']?.toString(),
      roleType: json['roleType']?.toString(),
      primaryFunction: toInt(json['primaryFunction']),
      customPrimaryFunction: json['customPrimaryFunction']?.toString(),
      primarySector: toInt(json['primarySector']),
      customPrimarySector: json['customPrimarySector']?.toString(),
      employer: json['employer']?.toString(),
      secondaryFunction: toInt(json['secondaryFunction']),
      secondarySector: toInt(json['secondarySector']),
      achievements: json['achievements']?.toString(),
      resume: json['resume']?.toString(),
      idType: json['idType']?.toString(),
      idFile: json['idFile']?.toString(),
      profile: json['profile']?.toString(),
      skillsCsv: json['skills_csv']?.toString(), // <-- Added field
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      password: json['password']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'lastName': lastName,
      'dob': dob,
      'location': location,
      'country': country,
      'continent': continent,
      'phone': phone,
      'email': email,
      'alternateEmail': alternateEmail,
      'experience': experience,
      'ctc': ctc,
      'linkedin': linkedin,
      'roleType': roleType,
      'primaryFunction': primaryFunction,
      'customPrimaryFunction': customPrimaryFunction,
      'primarySector': primarySector,
      'customPrimarySector': customPrimarySector,
      'employer': employer,
      'secondaryFunction': secondaryFunction,
      'secondarySector': secondarySector,
      'achievements': achievements,
      'resume': resume,
      'idType': idType,
      'idFile': idFile,
      'profile': profile,
      'skills_csv': skillsCsv,  
      'created_at': createdAt?.toIso8601String(),
      'password': password,
      'status': status,
    };
  }
}
