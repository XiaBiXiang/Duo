import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/couple_service.dart';

/// Single shared Appwrite Client.
final clientProvider = Provider<Client>((ref) {
  return Client()
    ..setEndpoint(AppConstants.appwriteEndpoint)
    ..setProject(AppConstants.appwriteProjectId);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(clientProvider));
});

final coupleServiceProvider = Provider<CoupleService>((ref) {
  return CoupleService(ref.watch(clientProvider));
});

final databasesProvider = Provider<Databases>((ref) {
  return Databases(ref.watch(clientProvider));
});

final storageProvider = Provider<Storage>((ref) {
  return Storage(ref.watch(clientProvider));
});
