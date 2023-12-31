import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/constants.dart';
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
  invalidPassword
}

final dio = Dio();

Future<dynamic> checkCredentialsAndGetToken(
    String usernameOrEmail, String password) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/user/login',
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
    debugPrint(e.response?.data.toString());
    return ReturnTypes.fail;
  }
}

Future<dynamic> signUp(String username, String email, String password) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/user/signup',
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

    debugPrint(e.response!.data.toString());

    if (e.response!.data['error'] == 'Email already in-use.') {
      return ReturnTypes.emailTaken;
    } else if (e.response!.data['error'] == 'Username already in-use.') {
      return ReturnTypes.usernameTaken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> checkOTP(String pin, String token) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/verifyEmail',
      data: {
        "pin": pin,
        // "email": email,
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

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/task',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/task',
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
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/task/$taskId',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ReturnTypes.success;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> editTaskStatusFromDB(String taskId, String status) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    await dio.patch(
      '${Constants.address}/task/$taskId',
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

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> editTaskFromDB(
  String? taskId,
  String? taskName,
  String? taskDescription,
  String? priority,
  String? etaDate,
  String? color,
) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  Map data = {};
  if (taskName != null) {
    data['title'] = taskName;
  }
  if (taskDescription != null) {
    data['description'] = taskDescription;
  }
  if (priority != null) {
    data['priority'] = priority;
  }
  if (etaDate != null) {
    data['estimatedDate'] = etaDate;
  }
  if (color != null) {
    data['color'] = color;
  }

  try {
    await dio.patch(
      '${Constants.address}/task/$taskId',
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ReturnTypes.success;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/user/2FactorAuth',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data['is2FAEnabled'];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;
    debugPrint(e.response?.data.toString());
    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/user/BiometricAuth',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data['isBiometricAuthEnabled'];
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
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
      '${Constants.address}/user/info',
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

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> sendResetPasswordOTP(String signature) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/user/Request/ResetPassword',
      data: {
        "signature": signature,
      },
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    return ReturnTypes.fail;
  }
}

Future<dynamic> sendDeleteAccountOTP() async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    await dio.get(
      '${Constants.address}/user/Request/DeleteAccount',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return ReturnTypes.success;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> checkResetPasswordOTP(String pin, String email) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/ResetPassword',
      data: {
        "pin": pin,
        "email": email,
      },
    );

    debugPrint(response.data.toString());
    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'UnAuthorized Access!') {
      return ReturnTypes.fail;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> checkDeleteAccountOTP(String pin) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.delete(
      '${Constants.address}/user/DeleteAccount',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
      data: {
        "pin": pin,
      },
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'UnAuthorized Access!') {
      return ReturnTypes.fail;
    }

    if (e.response?.statusCode == 401 ||
        e.response?.statusCode == 403 ||
        e.response?.data['error'] == "Expired token") {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> changePassword(String oldPassword, String newPassword) async {
  final String token = await UserToken.getToken();
  if (token == '') {
    return ReturnTypes.invalidToken;
  }

  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/user/ChangePassword',
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'Invalid Password!') {
      return ReturnTypes.invalidPassword;
    } else if (e.response!.data['error'] == 'Expired token') {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}

Future<dynamic> resetPassword(String newPassword, String token) async {
  try {
    Response response;
    response = await dio.post(
      '${Constants.address}/user/ResetPassword',
      data: {
        "password": newPassword,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    if (e.response == null) return ReturnTypes.error;

    if (e.response!.data['error'] == 'Expired token') {
      return ReturnTypes.invalidToken;
    }

    return ReturnTypes.fail;
  }
}
