import 'package:appwrite/appwrite.dart';
import '../core/constants/app_constants.dart';
import '../models/task.dart';
import '../models/moment.dart';

/// Cloud database service using Appwrite.
/// All operations are scoped by coupleId for data isolation between couples.
class DatabaseService {
  final Databases _db;
  final Storage _storage;

  DatabaseService(this._db, this._storage);

  // ── Tasks CRUD ────────────────────────────────────────

  Future<List<Task>> getTasks(String coupleId) async {
    final response = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.tasksCollectionId,
      queries: [
        Query.equal('couple_id', coupleId),
        Query.orderDesc('created_at'),
      ],
    );
    return response.documents.map((doc) => Task.fromJson(doc.data)).toList();
  }

  Future<Task> createTask({
    required String coupleId,
    required String createdBy,
    required String title,
    String? description,
    String? category,
  }) async {
    final id = ID.unique();
    final now = DateTime.now();
    final data = <String, dynamic>{
      'couple_id': coupleId,
      'title': title,
      'status': 'pending',
      'created_by': createdBy,
      'created_at': now.toIso8601String(),
    };
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category;

    await _db.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.tasksCollectionId,
      documentId: id,
      data: data,
    );
    return Task(
      id: id,
      coupleId: coupleId,
      title: title,
      description: description,
      category: category,
      createdBy: createdBy,
      createdAt: now,
    );
  }

  Future<Task> updateTask(Task task) async {
    final data = <String, dynamic>{
      'title': task.title,
      'status': task.status.name,
    };
    if (task.description != null) data['description'] = task.description;
    if (task.category != null) data['category'] = task.category;
    if (task.completedAt != null) {
      data['completed_at'] = task.completedAt!.toIso8601String();
    }
    await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.tasksCollectionId,
      documentId: task.id,
      data: data,
    );
    return task;
  }

  Future<void> deleteTask(String taskId) async {
    await _db.deleteDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.tasksCollectionId,
      documentId: taskId,
    );
  }

  // ── Moments CRUD ──────────────────────────────────────

  Future<List<Moment>> getMoments(String coupleId, String taskId) async {
    final response = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.momentsCollectionId,
      queries: [
        Query.equal('couple_id', coupleId),
        Query.equal('task_id', taskId),
        Query.orderDesc('created_at'),
      ],
    );
    return response.documents.map((doc) => Moment.fromJson(doc.data)).toList();
  }

  Future<Moment> createMoment({
    required String coupleId,
    required String taskId,
    required String createdBy,
    String? reflection,
    String? photoUrl,
    String? localPhotoPath,
  }) async {
    final id = ID.unique();
    final now = DateTime.now();
    final data = <String, dynamic>{
      'couple_id': coupleId,
      'task_id': taskId,
      'created_by': createdBy,
      'created_at': now.toIso8601String(),
    };
    if (reflection != null) data['reflection'] = reflection;
    if (photoUrl != null) data['photo_url'] = photoUrl;
    if (localPhotoPath != null) data['local_photo_path'] = localPhotoPath;

    await _db.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.momentsCollectionId,
      documentId: id,
      data: data,
    );
    return Moment(
      id: id,
      coupleId: coupleId,
      taskId: taskId,
      reflection: reflection,
      photoUrl: photoUrl,
      localPhotoPath: localPhotoPath,
      createdBy: createdBy,
      createdAt: now,
    );
  }

  Future<void> updateMoment(Moment moment) async {
    await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.momentsCollectionId,
      documentId: moment.id,
      data: {
        'reflection': moment.reflection,
        'photo_url': moment.photoUrl,
        'local_photo_path': moment.localPhotoPath,
      },
    );
  }

  Future<void> deleteMoment(String momentId) async {
    await _db.deleteDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.momentsCollectionId,
      documentId: momentId,
    );
  }

  // ── Photo Storage ─────────────────────────────────────

  Future<String> uploadPhoto(String filePath) async {
    final file = InputFile.fromPath(path: filePath);
    final response = await _storage.createFile(
      bucketId: AppConstants.photosBucketId,
      fileId: ID.unique(),
      file: file,
    );
    return response.$id;
  }

  String getPhotoUrl(String fileId) {
    return '${AppConstants.appwriteEndpoint}/storage/buckets/${AppConstants.photosBucketId}/files/$fileId/view?project=${AppConstants.appwriteProjectId}';
  }

  Future<void> deletePhoto(String fileId) async {
    await _storage.deleteFile(
      bucketId: AppConstants.photosBucketId,
      fileId: fileId,
    );
  }
}
