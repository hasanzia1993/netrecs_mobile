import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nexthour/models/login_model.dart';
import 'package:nexthour/models/user_profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileModel? userProfileModel;
  LoginModel? loginModel;

  Future<UserProfileModel?> getUserProfile(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse(APIData.userProfileApi), headers: {
        // "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      });
      if (response.statusCode == 200) {
        userProfileModel =
            UserProfileModel.fromJson(json.decode(response.body));
      } else {
        await storage.deleteAll();
        Navigator.pushNamed(context, RoutePaths.loginHome);
        throw "Can't get user profile";
      }
    } catch (error) {
      return null;
    }
    notifyListeners();
    return userProfileModel;
  }
}
