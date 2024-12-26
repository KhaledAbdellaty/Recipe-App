import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  bool isUserCahed();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  static const userKey = 'CACHED_USER';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(userKey, user.toJson().toString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(userKey);
    if (jsonString != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(jsonString as Map));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(userKey);
  }

  @override
  bool isUserCahed() {
    return _prefs.containsKey(userKey);
  }
}
