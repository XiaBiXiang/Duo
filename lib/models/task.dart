/// Task model for the couple's bucket list.
class Task {
  final String id;
  final String coupleId;
  final String title;
  final String? description;
  final TaskStatus status;
  final String? category;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.coupleId,
    required this.title,
    this.description,
    this.status = TaskStatus.pending,
    this.category,
    required this.createdBy,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    String? category,
    DateTime? completedAt,
  }) {
    return Task(
      id: id,
      coupleId: coupleId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      createdBy: createdBy,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['\$id'] as String? ?? json['id'] as String,
      coupleId: json['couple_id'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
      status: TaskStatus.fromString(json['status'] as String? ?? 'pending'),
      category: json['category'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? json['createdAt'] as String,
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'couple_id': coupleId,
        'title': title,
        'description': description,
        'status': status.name,
        'category': category,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };
}

enum TaskStatus {
  pending,
  completed;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TaskStatus.pending,
    );
  }
}
