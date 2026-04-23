import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDarkMode;
  final bool isNotificationEnabled;
  final bool isLoading;

  const SettingsState({
    this.isDarkMode = false,
    this.isNotificationEnabled = true,
    this.isLoading = true,
  });

  SettingsState copyWith({bool? isDarkMode, bool? isNotificationEnabled, bool? isLoading}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      isNotificationEnabled: prefs.getBool('isNotificationEnabled') ?? true,
      isLoading: false,
    );
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    state = state.copyWith(isDarkMode: value);
  }

  Future<void> setNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', value);
    state = state.copyWith(isNotificationEnabled: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
