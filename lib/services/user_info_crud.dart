import 'package:hive/hive.dart';

class UserInfoCRUD {
  final _userInfoBox = Hive.box('userInfo');

  void setUserInfo(String username, String email) {
    _userInfoBox.put('username', username);
    _userInfoBox.put('email', email);

    //todo add userid, 2fa setting, picture,
  }

  String getUsername() {
    return _userInfoBox.get('username');
  }

  String getEmail() {
    return _userInfoBox.get('email');
  }

  void deleteUserInfo() {
    _userInfoBox.deleteAll(['username','email']);
  }
}

