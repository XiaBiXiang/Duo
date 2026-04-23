import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/couple.dart';
import '../services/couple_service.dart';
import 'appwrite_provider.dart';
import 'auth_provider.dart';

class CoupleState {
  final Couple? couple;
  final bool isLoading;
  final String? error;

  const CoupleState({this.couple, this.isLoading = false, this.error});

  bool get isPaired => couple?.isPaired ?? false;
  String? get coupleId => couple?.id;

  String? get partnerName {
    final c = couple;
    if (c == null) return null;
    // If we're user1, partner is user2; if we're user2, partner is user1
    // We need userId to determine, so we return both names and let the UI decide
    return null; // Use couple provider with auth to get partner name
  }

  CoupleState copyWith({Couple? couple, bool? isLoading, String? error}) {
    return CoupleState(
      couple: couple ?? this.couple,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CoupleNotifier extends StateNotifier<CoupleState> {
  final CoupleService _coupleService;
  final String? _userId;
  final String? _userName;

  CoupleNotifier(this._coupleService, this._userId, this._userName)
      : super(const CoupleState(isLoading: true)) {
    if (_userId != null) _loadCouple();
  }

  Future<void> _loadCouple() async {
    state = state.copyWith(isLoading: true);
    try {
      final couple = await _coupleService.getCoupleForUser(_userId!);
      state = CoupleState(couple: couple);
    } catch (e) {
      state = CoupleState(error: e.toString());
    }
  }

  Future<void> createCouple() async {
    if (_userId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final couple = await _coupleService.createCouple(_userId!, _userName ?? '');
      state = CoupleState(couple: couple);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> joinCouple(String inviteCode) async {
    if (_userId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final couple = await _coupleService.joinCouple(inviteCode, _userId!, _userName ?? '');
      state = CoupleState(couple: couple);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> reload() async {
    await _loadCouple();
  }

  Future<void> unpair() async {
    if (_userId == null) return;
    final couple = state.couple;
    if (couple == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _coupleService.deleteCouple(couple.id);
      state = const CoupleState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final coupleProvider = StateNotifierProvider<CoupleNotifier, CoupleState>((ref) {
  final userId = ref.watch(authProvider).user?.$id;
  final userName = ref.watch(authProvider).user?.name;
  return CoupleNotifier(ref.watch(coupleServiceProvider), userId, userName);
});
