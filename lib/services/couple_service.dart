import 'dart:math';
import 'package:appwrite/appwrite.dart';
import '../core/constants/app_constants.dart';
import '../models/couple.dart';

/// Service for managing couple spaces (create, join, get).
class CoupleService {
  final Databases _db;

  CoupleService(Client client) : _db = Databases(client);

  Future<Couple> createCouple(String userId, String userName) async {
    final code = _generateInviteCode();
    final doc = await _db.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      documentId: ID.unique(),
      data: {
        'user1_id': userId,
        'user2_id': null,
        'invite_code': code,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'user1_name': userName,
      },
    );
    return Couple.fromJson(doc.data);
  }

  Future<Couple> joinCouple(String inviteCode, String userId, String userName) async {
    final response = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      queries: [Query.equal('invite_code', inviteCode)],
    );

    if (response.documents.isEmpty) {
      throw Exception('邀请码无效');
    }

    final doc = response.documents.first;

    // Check if already paired
    final existingUser2 = doc.data['user2_id'] as String?;
    if (existingUser2 != null && existingUser2.isNotEmpty) {
      throw Exception('该空间已满，无法加入');
    }

    // Can't join your own space
    if (doc.data['user1_id'] == userId) {
      throw Exception('不能加入自己创建的空间');
    }

    final updated = await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      documentId: doc.$id,
      data: {
        'user2_id': userId,
        'user2_name': userName,
      },
    );

    return Couple.fromJson(updated.data);
  }

  Future<Couple?> getCoupleForUser(String userId) async {
    // Try as user1
    var response = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      queries: [Query.equal('user1_id', userId)],
    );
    if (response.documents.isNotEmpty) {
      return Couple.fromJson(response.documents.first.data);
    }

    // Try as user2
    response = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      queries: [Query.equal('user2_id', userId)],
    );
    if (response.documents.isNotEmpty) {
      return Couple.fromJson(response.documents.first.data);
    }

    return null;
  }

  Future<void> deleteCouple(String coupleId) async {
    await _db.deleteDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.couplesCollectionId,
      documentId: coupleId,
    );
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
