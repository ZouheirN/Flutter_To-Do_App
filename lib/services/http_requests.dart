import 'package:dio/dio.dart';

enum ReturnTypes {
  success,
  fail,
  error,
}

final dio = Dio();

Future<dynamic> checkCredentials(
    String usernameOrEmail, String password) async {
  try {
    await dio.post(
      'https://todobuddy.onrender.com/api/user/login',
      data: {
        "signature": usernameOrEmail,
        "password": password,
      },
    );
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    print('Error: ${e.response!.data}');
    return ReturnTypes.fail;
  }

  return ReturnTypes.success;
}
