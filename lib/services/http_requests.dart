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
  emailTaken,
  usernameTaken,
}

final dio = Dio();

Future<dynamic> checkCredentialsAndGetToken(
    String usernameOrEmail, String password) async {
  try {
    Response response;
    response = await dio.post(
      'https://todobuddy.onrender.com/api/user/login',
      data: {
        "signature": usernameOrEmail,
        "password": password,
      },
    );

    return {
      'token': response.data["token"],
      'username': response.data["username"],
      'email': response.data["email"],
      'is2FAEnabled': response.data["is2FAEnabled"],
      'isBiometricAuthEnabled': response.data["isBiometricAuthEnabled"],
      'isVerified': response.data["isVerified"],
    };
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    return ReturnTypes.fail;
  }
}

Future<dynamic> signUp(String username, String email, String password) async {
  try {
    Response response;
    response = await dio.post(
      'https://todobuddy.onrender.com/api/user/signup',
      data: {
        "username": username,
        "password": password,
        "email": email,
      },
    );

    return {
      'token': response.data["token"],
    };
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'Email already in-use.') {
      return ReturnTypes.emailTaken;
    } else if (e.response!.data['error'] == 'Username already in-use.') {
      return ReturnTypes.usernameTaken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> checkOTP(String pin, String email, String token) async {
  try {
    Response response;
    response = await dio.post(
      'https://todobuddy.onrender.com/api/verifyEmail',
      data: {
        "pin": pin,
        "email": email,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return {
      'token': response.data["token"],
      'username': response.data["username"],
      'email': response.data["email"],
      'is2FAEnabled': response.data["is2FAEnabled"],
      'isBiometricAuthEnabled': response.data["isBiometricAuthEnabled"],
    };
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'UnAuthorized Access!') {
      return ReturnTypes.fail;
    }

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> getTasksFromDB() async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.get(
      'https://todobuddy.onrender.com/api/task',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }
    return ReturnTypes.fail;
  }
}

Future<dynamic> addTaskToDB(String title, String description, String priority,
    String color, String estimatedDate) async {
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
        "estimatedDate": estimatedDate,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return [response.data["_id"], response.data["createdAt"]];
  } on DioException catch (e) {
    print(e.response?.data);
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }
    return ReturnTypes.fail;
  }
}

Future<dynamic> deleteTaskFromDB(String taskId) async {
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

Future<dynamic> editTaskFromDB(String taskId, String status) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    await dio.patch(
      'https://todobuddy.onrender.com/api/task/$taskId',
      data: {
        'status': status,
      },
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

Future<dynamic> toggle2FA() async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.get(
      'https://todobuddy.onrender.com/api/user/2FactorAuth',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(response.data);
    return response.data['is2FAEnabled'];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> toggleBiometricAuth() async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.get(
      'https://todobuddy.onrender.com/api/user/BiometricAuth',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);
    return response.data['isBiometricAuthEnabled'];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> getUserOptions() async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.get(
      'https://todobuddy.onrender.com/api/user/info',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );


    return {
      'is2FAEnabled': response.data["is2FAEnabled"],
      'isBiometricAuthEnabled': response.data["isBiometricAuthEnabled"],
    };
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}
