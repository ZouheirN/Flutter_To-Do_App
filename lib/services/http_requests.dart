import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/user_info_crud.dart';

enum ReturnTypes {
  success,
  fail,
  error,
  invalidToken,
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

Future<dynamic> addTaskToDB(String title, String description, String priority,
    String color, BuildContext context) async {
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
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);
    return response.data["_id"];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    print('Error: ${e.response!.data}');
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }
    return ReturnTypes.fail;
  }
}

Future<dynamic> deleteTaskFromDB(String taskId, BuildContext context) async {
  final token = UserInfoCRUD().getToken();

  try {
    await dio.delete(
      'https://todobuddy.onrender.com/api/task/$taskId',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ReturnTypes.success;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    print('Error: ${e.response!.data}');

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}
