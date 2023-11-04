import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo_app/services/user_info_crud.dart';

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

Future<dynamic> addTaskToDB(String title, String description,
    String priority, String color) async {

  final token = UserInfoCRUD().getToken();

  try {
    Response response;
    response = await dio.post(
      'https://todobuddy.onrender.com/api/task',
      data: {
        "title": title,
        "description": description,
        "status": "Unfinished",
        "priority": priority,
        "color": color,
      },
    );

    //todo check token validation

    final data = jsonDecode(response.data);
    return data["_id"];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    print('Error: ${e.response!.data}');
    return ReturnTypes.fail;
  }
}
