// user_profile_model.dart

class UserProfile {
  final Preferences? preferences;
  final AboutMe? aboutMe;
  final List<Experience>? experience;
  final List<Education>? education;
  final List<Language>? languages;
  final List<OnlineProfile>? onlineProfiles;
  final BasicDetails? basicDetails;
  final List<Skill>? skills;

  UserProfile({
    this.preferences,
    this.aboutMe,
    this.experience,
    this.education,
    this.languages,
    this.onlineProfiles,
    this.basicDetails,
    this.skills,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return UserProfile(
      preferences: data['preferences'] != null
          ? Preferences.fromJson(data['preferences'])
          : null,
      aboutMe:
          data['aboutMe'] != null ? AboutMe.fromJson(data['aboutMe']) : null,
      experience: data['experience'] != null
          ? List<Experience>.from(
              (data['experience'] as List)
                  .map((x) => Experience.fromJson(x)),
            )
          : [],
      education: data['education'] != null
          ? List<Education>.from(
              (data['education'] as List).map((x) => Education.fromJson(x)),
            )
          : [],
      languages: data['languages'] != null
          ? List<Language>.from(
              (data['languages'] as List).map((x) => Language.fromJson(x)),
            )
          : [],
      onlineProfiles: data['onlineProfiles'] != null
          ? List<OnlineProfile>.from(
              (data['onlineProfiles'] as List)
                  .map((x) => OnlineProfile.fromJson(x)),
            )
          : [],
      basicDetails: data['basicDetails'] != null
          ? BasicDetails.fromJson(data['basicDetails'])
          : null,
      skills: data['skills'] != null
          ? List<Skill>.from(
              (data['skills'] as List).map((x) => Skill.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferences': preferences?.toJson(),
      'aboutMe': aboutMe?.toJson(),
      'experience': experience?.map((x) => x.toJson()).toList(),
      'education': education?.map((x) => x.toJson()).toList(),
      'languages': languages?.map((x) => x.toJson()).toList(),
      'onlineProfiles': onlineProfiles?.map((x) => x.toJson()).toList(),
      'basicDetails': basicDetails?.toJson(),
      'skills': skills?.map((x) => x.toJson()).toList(),
    };
  }
}

class Preferences {
  final int? id;
  final int? userId;
  final String? lookingFor;
  final String? preferredBudget;
  final String? budgetCurrency;
  final String? budgetPeriod;
  final int? availabilityHoursPerWeek;
  final String? availabilityType;
  final int? preferredDurationMin;
  final int? preferredDurationMax;
  final String? preferredDurationType;
  final String? workType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Preferences({
    this.id,
    this.userId,
    this.lookingFor,
    this.preferredBudget,
    this.budgetCurrency,
    this.budgetPeriod,
    this.availabilityHoursPerWeek,
    this.availabilityType,
    this.preferredDurationMin,
    this.preferredDurationMax,
    this.preferredDurationType,
    this.workType,
    this.createdAt,
    this.updatedAt,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      id: json['id'],
      userId: json['user_id'],
      lookingFor: json['looking_for'],
      preferredBudget: json['preferred_budget'],
      budgetCurrency: json['budget_currency'],
      budgetPeriod: json['budget_period'],
      availabilityHoursPerWeek: json['availability_hours_per_week'],
      availabilityType: json['availability_type'],
      preferredDurationMin: json['preferred_duration_min'],
      preferredDurationMax: json['preferred_duration_max'],
      preferredDurationType: json['preferred_duration_type'],
      workType: json['work_type'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'looking_for': lookingFor,
      'preferred_budget': preferredBudget,
      'budget_currency': budgetCurrency,
      'budget_period': budgetPeriod,
      'availability_hours_per_week': availabilityHoursPerWeek,
      'availability_type': availabilityType,
      'preferred_duration_min': preferredDurationMin,
      'preferred_duration_max': preferredDurationMax,
      'preferred_duration_type': preferredDurationType,
      'work_type': workType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class AboutMe {
  final int? id;
  final int? userId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AboutMe({
    this.id,
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutMe.fromJson(Map<String, dynamic> json) {
    return AboutMe(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Experience {
  final int? id;
  final int? userId;
  final String? companyName;
  final String? role;
  final String? employmentType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isCurrent;
  final int? isRemote;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Experience({
    this.id,
    this.userId,
    this.companyName,
    this.role,
    this.employmentType,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.isRemote,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      role: json['role'],
      employmentType: json['employment_type'],
      startDate:
          json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isCurrent: json['is_current'],
      isRemote: json['is_remote'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_name': companyName,
      'role': role,
      'employment_type': employmentType,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current': isCurrent,
      'is_remote': isRemote,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Education {
  final int? id;
  final int? userId;
  final String? institutionName;
  final String? degree;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Education({
    this.id,
    this.userId,
    this.institutionName,
    this.degree,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.createdAt,
    this.updatedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      userId: json['user_id'],
      institutionName: json['institution_name'],
      degree: json['degree'],
      startDate:
          json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isCurrent: json['is_current'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'institution_name': institutionName,
      'degree': degree,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current': isCurrent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Language {
  final int? id;
  final int? userId;
  final String? languageName;
  final String? proficiencyLevel;
  final int? canRead;
  final int? canWrite;
  final int? canSpeak;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Language({
    this.id,
    this.userId,
    this.languageName,
    this.proficiencyLevel,
    this.canRead,
    this.canWrite,
    this.canSpeak,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      userId: json['user_id'],
      languageName: json['language_name'],
      proficiencyLevel: json['proficiency_level'],
      canRead: json['can_read'],
      canWrite: json['can_write'],
      canSpeak: json['can_speak'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'language_name': languageName,
      'proficiency_level': proficiencyLevel,
      'can_read': canRead,
      'can_write': canWrite,
      'can_speak': canSpeak,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class OnlineProfile {
  final int? id;
  final int? userId;
  final String? platformType;
  final String? profileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OnlineProfile({
    this.id,
    this.userId,
    this.platformType,
    this.profileUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory OnlineProfile.fromJson(Map<String, dynamic> json) {
    return OnlineProfile(
      id: json['id'],
      userId: json['user_id'],
      platformType: json['platform_type'],
      profileUrl: json['profile_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'platform_type': platformType,
      'profile_url': profileUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class BasicDetails {
  final int? id;
  final int? userId;
  final String? email;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BasicDetails({
    this.id,
    this.userId,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Skill {
  final int? id;
  final int? userId;
  final String? skillName;
  final String? skillCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Skill({
    this.id,
    this.userId,
    this.skillName,
    this.skillCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      userId: json['user_id'],
      skillName: json['skill_name'],
      skillCategory: json['skill_category'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'skill_name': skillName,
      'skill_category': skillCategory,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
