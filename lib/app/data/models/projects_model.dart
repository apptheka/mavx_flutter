// project_response_model.dart

class ProjectResponse {
  final int? status;
  final String? message;
  final List<ProjectModel>? data;

  ProjectResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data']['data'] != null
          ? (json['data']['data'] as List)
              .map((item) => ProjectModel.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class ProjectModel {
  final int? id;
  final String? projectTitle;
  final String? projectType;
  final int? industry;
  final int? requiredExperts;
  final String? requiredManager;
  final int? duration;
  final String? durationType;
  final DateTime? estStartDate;
  final String? description;
  final String? attachment1Title;
  final String? projectFile;
  final String? attachment2Title;
  final String? projectFile2;
  final int? clientId;
  final String? projectCoordinator;
  final String? coordinatorEmail;
  final String? coordinatorMobile;
  final double? projectCost;
  final double? budget;
  final String? projectStatus;
  final DateTime? startDate;
  final DateTime? completionDate;
  final int? creationBy;
  final DateTime? creationDate;
  final int? total;

  ProjectModel({
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
    this.projectCoordinator,
    this.coordinatorEmail,
    this.coordinatorMobile,
    this.projectCost,
    this.budget,
    this.projectStatus,
    this.startDate,
    this.completionDate,
    this.creationBy,
    this.creationDate,
    this.total,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int?,
      projectTitle: json['project_title'] as String?,
      projectType: json['project_type'] as String?,
      industry: json['industry'] as int?,
      requiredExperts: json['required_experts'] as int?,
      requiredManager: json['required_manager'] as String?,
      duration: json['duration'] as int?,
      durationType: json['duration_type'] as String?,
      estStartDate: json['est_start_date'] != null
          ? DateTime.tryParse(json['est_start_date'])
          : null,
      description: json['description'] as String?,
      attachment1Title: json['attachment1_title'] as String?,
      projectFile: json['project_file'] as String?,
      attachment2Title: json['attachment2_title'] as String?,
      projectFile2: json['project_file2'] as String?,
      clientId: json['client_id'] as int?,
      projectCoordinator: json['project_cordinator'] as String?,
      coordinatorEmail: json['cordinator_email'] as String?,
      coordinatorMobile: json['cordinator_mobile'] as String?,
      projectCost: (json['project_cost'] as num?)?.toDouble(),
      budget: (json['budget'] as num?)?.toDouble(),
      projectStatus: json['project_status'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      completionDate: json['completion_date'] != null
          ? DateTime.tryParse(json['completion_date'])
          : null,
      creationBy: json['creation_by'] as int?,
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'])
          : null,
      total: json['total'] as int?,
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
      'est_start_date': estStartDate?.toIso8601String(),
      'description': description,
      'attachment1_title': attachment1Title,
      'project_file': projectFile,
      'attachment2_title': attachment2Title,
      'project_file2': projectFile2,
      'client_id': clientId,
      'project_cordinator': projectCoordinator,
      'cordinator_email': coordinatorEmail,
      'cordinator_mobile': coordinatorMobile,
      'project_cost': projectCost,
      'budget': budget,
      'project_status': projectStatus,
      'start_date': startDate?.toIso8601String(),
      'completion_date': completionDate?.toIso8601String(),
      'creation_by': creationBy,
      'creation_date': creationDate?.toIso8601String(),
      'total': total,
    };
  }
}
