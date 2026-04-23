/// Moment model — a photo + reflection attached to a Task.
class Moment {
  final String id;
  final String coupleId;
  final String taskId;
  final String? photoUrl;
  final String? localPhotoPath;
  final String? reflection;
  final String createdBy;
  final DateTime createdAt;

  const Moment({
    required this.id,
    required this.coupleId,
    required this.taskId,
    this.photoUrl,
    this.localPhotoPath,
    this.reflection,
    required this.createdBy,
    required this.createdAt,
  });

  Moment copyWith({
    String? photoUrl,
    String? localPhotoPath,
    String? reflection,
  }) {
    return Moment(
      id: id,
      coupleId: coupleId,
      taskId: taskId,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      reflection: reflection ?? this.reflection,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  factory Moment.fromJson(Map<String, dynamic> json) {
    return Moment(
      id: json['\$id'] as String? ?? json['id'] as String,
      coupleId: json['couple_id'] as String? ?? '',
      taskId: json['task_id'] as String? ?? json['taskId'] as String,
      photoUrl: json['photo_url'] as String?,
      localPhotoPath: json['local_photo_path'] as String?,
      reflection: json['reflection'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? json['createdAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'couple_id': coupleId,
        'task_id': taskId,
        'photo_url': photoUrl,
        'local_photo_path': localPhotoPath,
        'reflection': reflection,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };
}
