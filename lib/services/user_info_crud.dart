import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/services/user_token.dart';

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
    UserToken.setToken(token);
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

  void set2FA(bool fa) {
    _userInfoBox.put('2fa_enabled', fa);
  }

  void deleteUserInfo() {
    _userInfoBox.deleteAll([
      'username',
      'email',
      '2fa_enabled',
      'auth_enabled',
    ]);
    UserToken.deleteToken();
  }
}
