import 'package:hive/hive.dart';

class OnboardCRUD {
  final _userInfoBox = Hive.box('onboard');

  void setOnboardFinished() {
    _userInfoBox.put('finished', true);
  }
}

