import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/services/user_token.dart';
import 'package:todo_app/widgets/global_snackbar.dart';
import '../screens/welcome_screen.dart';

void invalidTokenResponse(BuildContext context) {
  UserInfoCRUD().deleteUserInfo();
  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
  );
  showGlobalSnackBar('Your session has expired. Please log in again.');
}

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

    return ReturnTypes.fail;
  }

  return ReturnTypes.success;
}

Future<dynamic> addTaskToDB(String title, String description, String priority,
    String color, BuildContext context) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

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

    return [response.data["_id"], response.data["createdAt"]];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }
    return ReturnTypes.fail;
  }
}

Future<dynamic> deleteTaskFromDB(String taskId, BuildContext context) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

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

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}
