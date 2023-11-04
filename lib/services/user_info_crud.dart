import 'package:hive_flutter/hive_flutter.dart';

class UserInfoCRUD {
  final _userInfoBox = Hive.box('userInfo');

  Future<void> setUserInfo({
    required String username,
    required String email,
    required bool is2FAEnabled,
    required bool isBiometricAuthEnabled,
    required String token,
  }) async {
    _userInfoBox.put('username', username);
    _userInfoBox.put('email', email);
    _userInfoBox.put('2fa_enabled', is2FAEnabled);
    _userInfoBox.put('auth_enabled', isBiometricAuthEnabled);
    _userInfoBox.put('token', token);
  }

  String getUsername() {
    return _userInfoBox.get('username');
  }

  String getEmail() {
    return _userInfoBox.get('email');
  }

  bool get2FAEnabled() {
    return _userInfoBox.get('2fa_enabled');
  }

  bool getAuthEnabled() {
    return _userInfoBox.get('auth_enabled') ?? false;
  }

  void setAuth(bool auth) {
    _userInfoBox.put('auth_enabled', auth);
  }

  String getToken() {
    return _userInfoBox.get('token');
  }

  void deleteUserInfo() {
    _userInfoBox.deleteAll([
      'username',
      'email',
      '2fa_enabled',
      'auth_enabled',
      'token',
    ]);
  }
}
