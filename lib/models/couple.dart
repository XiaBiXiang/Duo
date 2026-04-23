/// Couple model — represents a shared space between two partners.
class Couple {
  final String id;
  final String user1Id;
  final String? user2Id;
  final String inviteCode;
  final DateTime createdAt;
  final String? user1Name;
  final String? user2Name;

  const Couple({
    required this.id,
    required this.user1Id,
    this.user2Id,
    required this.inviteCode,
    required this.createdAt,
    this.user1Name,
    this.user2Name,
  });

  bool get isPaired => user2Id != null;

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      id: json['\$id'] as String? ?? json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String?,
      inviteCode: json['invite_code'] as String,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? json['createdAt'] as String,
      ),
      user1Name: json['user1_name'] as String?,
      user2Name: json['user2_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user1_id': user1Id,
        'user2_id': user2Id,
        'invite_code': inviteCode,
        'created_at': createdAt.toIso8601String(),
        'user1_name': user1Name,
        'user2_name': user2Name,
      };
}
