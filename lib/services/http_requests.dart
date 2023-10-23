import 'package:dio/dio.dart';

final dio = Dio();

Future<void> login(String usernameOrEmail, String password) async {
  Response response;
  response = await dio.post(
    'https://todobuddy.onrender.com/api/user/login',
    data: {
      "signature": usernameOrEmail,
      "password": password,
    },
  );
  print(response.data.toString());
}
