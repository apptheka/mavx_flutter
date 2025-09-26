class TimesheetsResponse {
  final int status;
  final String message;
  final List<Timesheet> data;

  TimesheetsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TimesheetsResponse.fromJson(Map<String, dynamic> json) {
    return TimesheetsResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Timesheet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Timesheet {
  final int id;
  final int expertId;
  final String expertName;
  final String expertEmail;
  final int projectId;
  final String projectName;
  final String workDate;
  final String taskDescription;
  final String startTime;
  final String endTime;
  final String totalHours;
  final String hourlyRate;
  final String amount;
  final String? notes;
  final String status;
  final String submittedAt;
  final String updatedAt;
  final int showList;

  Timesheet({
    required this.id,
    required this.expertId,
    required this.expertName,
    required this.expertEmail,
    required this.projectId,
    required this.projectName,
    required this.workDate,
    required this.taskDescription,
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.hourlyRate,
    required this.amount,
    this.notes,
    required this.status,
    required this.submittedAt,
    required this.updatedAt,
    required this.showList,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    return Timesheet(
      id: json['id'] as int,
      expertId: json['expert_id'] as int,
      expertName: json['expert_name'] as String,
      expertEmail: json['expert_email'] as String,
      projectId: json['project_id'] as int,
      projectName: json['project_name'] as String,
      workDate: json['work_date'] as String,
      taskDescription: json['task_description'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalHours: json['total_hours'] as String,
      hourlyRate: json['hourly_rate'] as String,
      amount: json['amount'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      submittedAt: json['submitted_at'] as String,
      updatedAt: json['updated_at'] as String,
      showList: json['showList'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expert_id': expertId,
      'expert_name': expertName,
      'expert_email': expertEmail,
      'project_id': projectId,
      'project_name': projectName,
      'work_date': workDate,
      'task_description': taskDescription,
      'start_time': startTime,
      'end_time': endTime,
      'total_hours': totalHours,
      'hourly_rate': hourlyRate,
      'amount': amount,
      'notes': notes,
      'status': status,
      'submitted_at': submittedAt,
      'updated_at': updatedAt,
      'showList': showList,
    };
  }
}
