class BookmarksResponseModel {
  final int? status;
  final String? message;
  final int? total;
  final List<Project>? projects;

  BookmarksResponseModel({
    this.status,
    this.message,
    this.total,
    this.projects,
  });

  factory BookmarksResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data']?['data'];
    return BookmarksResponseModel(
      status: json['status'],
      message: json['message'],
      total: data?['total'],
      projects: data?['projects'] != null
          ? List<Project>.from(
              (data['projects'] as List).map((x) => Project.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'total': total,
        'projects': projects?.map((x) => x.toJson()).toList(),
      },
    };
  }
}

class Project {
  final int? id;
  final String? projectTitle;
  final String? projectType;
  final int? industry;
  final int? requiredExperts;
  final String? requiredManager;
  final int? duration;
  final String? durationType;
  final String? estStartDate;
  final String? description;
  final String? attachment1Title;
  final String? projectFile;
  final String? attachment2Title;
  final String? projectFile2;
  final int? clientId;
  final String? projectCordinator;
  final String? cordinatorEmail;
  final String? cordinatorMobile;
  final int? projectCost;
  final int? budget;
  final String? projectStatus;
  final String? skillsJson;
  final String? ndaUrl;
  final String? startDate;
  final String? completionDate;
  final int? creationBy;
  final DateTime? creationDate;
  final int? bookmarkId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Project({
    this.id,
    this.projectTitle,
    this.projectType,
    this.industry,
    this.requiredExperts,
    this.requiredManager,
    this.duration,
    this.durationType,
    this.estStartDate,
    this.description,
    this.attachment1Title,
    this.projectFile,
    this.attachment2Title,
    this.projectFile2,
    this.clientId,
    this.projectCordinator,
    this.cordinatorEmail,
    this.cordinatorMobile,
    this.projectCost,
    this.budget,
    this.projectStatus,
    this.skillsJson,
    this.ndaUrl,
    this.startDate,
    this.completionDate,
    this.creationBy,
    this.creationDate,
    this.bookmarkId,
    this.createdAt,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projectTitle: json['project_title'],
      projectType: json['project_type'],
      industry: json['industry'],
      requiredExperts: json['required_experts'],
      requiredManager: json['required_manager'],
      duration: json['duration'],
      durationType: json['duration_type'],
      estStartDate: json['est_start_date'],
      description: json['description'],
      attachment1Title: json['attachment1_title'],
      projectFile: json['project_file'],
      attachment2Title: json['attachment2_title'],
      projectFile2: json['project_file2'],
      clientId: json['client_id'],
      projectCordinator: json['project_cordinator'],
      cordinatorEmail: json['cordinator_email'],
      cordinatorMobile: json['cordinator_mobile'],
      projectCost: json['project_cost'],
      budget: json['budget'],
      projectStatus: json['project_status'],
      skillsJson: json['skills_json'],
      ndaUrl: json['nda_url'],
      startDate: json['start_date'],
      completionDate: json['completion_date'],
      creationBy: json['creation_by'],
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'])
          : null,
      bookmarkId: json['bookmark_id'],
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
      'project_title': projectTitle,
      'project_type': projectType,
      'industry': industry,
      'required_experts': requiredExperts,
      'required_manager': requiredManager,
      'duration': duration,
      'duration_type': durationType,
      'est_start_date': estStartDate,
      'description': description,
      'attachment1_title': attachment1Title,
      'project_file': projectFile,
      'attachment2_title': attachment2Title,
      'project_file2': projectFile2,
      'client_id': clientId,
      'project_cordinator': projectCordinator,
      'cordinator_email': cordinatorEmail,
      'cordinator_mobile': cordinatorMobile,
      'project_cost': projectCost,
      'budget': budget,
      'project_status': projectStatus,
      'skills_json': skillsJson,
      'nda_url': ndaUrl,
      'start_date': startDate,
      'completion_date': completionDate,
      'creation_by': creationBy,
      'creation_date': creationDate?.toIso8601String(),
      'bookmark_id': bookmarkId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
