import 'package:hive_flutter/hive_flutter.dart';

class UserInfoCRUD {
  final _userInfoBox = Hive.box('userInfo');

  void setUserInfo(String username, String email) {
    _userInfoBox.put('username', username);
    _userInfoBox.put('email', email);

    //todo add userid, 2fa setting, picture, auth
  }

  String getUsername() {
    return _userInfoBox.get('username');
  }

  String getEmail() {
    return _userInfoBox.get('email');
  }

  bool get2FAEnabled() {
    return true;
    // return _userInfoBox.get('2fa_enabled');
  }

  bool getAuthEnabled() {
    return _userInfoBox.get('auth_enabled') ?? false;
  }

  void setAuth(bool auth) {
    _userInfoBox.put('auth_enabled', auth);
  }

  void deleteUserInfo() {
    _userInfoBox.deleteAll(['username','email','2fa_enabled']);
  }
}

