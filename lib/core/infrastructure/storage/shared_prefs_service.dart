import 'package:injectable/injectable.dart';

abstract interface class SharedPrefsService {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> setInt(String key, int value);
  int? getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

@LazySingleton(as: SharedPrefsService)
class SharedPrefsServiceImpl implements SharedPrefsService {
  final Map<String, dynamic> _store = {};

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => _store[key] = value;

  @override
  bool? getBool(String key) => _store[key] as bool?;

  @override
  Future<void> setInt(String key, int value) async => _store[key] = value;

  @override
  int? getInt(String key) => _store[key] as int?;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();
}
