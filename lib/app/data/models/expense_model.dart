class ExpensesResponse {
  final int status;
  final String message;
  final List<Expense> data;

  ExpensesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) {
    return ExpensesResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e))
              .toList() ??
          [],
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

class Expense {
  final int id;
  final int expertId;
  final int projectId;
  final String date;
  final String category;
  final String description;
  final String amount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String projectTitle;
  final int clientId;
  final String expertName;
  final String expertEmail;

  Expense({
    required this.id,
    required this.expertId,
    required this.projectId,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.projectTitle,
    required this.clientId,
    required this.expertName,
    required this.expertEmail,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? 0,
      expertId: json['expert_id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      projectTitle: json['project_title'] ?? '',
      clientId: json['client_id'] ?? 0,
      expertName: json['expert_name'] ?? '',
      expertEmail: json['expert_email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expert_id': expertId,
      'project_id': projectId,
      'date': date,
      'category': category,
      'description': description,
      'amount': amount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'project_title': projectTitle,
      'client_id': clientId,
      'expert_name': expertName,
      'expert_email': expertEmail,
    };
  }
}
