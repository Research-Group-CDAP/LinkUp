import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkup/constants.dart';
import 'package:linkup/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  User newUser = User.createConstructor(
    firstName: '',
    lastName: '',
    phoneNumber: '',
    email: '',
    password: '',
    profileImageURL:
        'https://firebasestorage.googleapis.com/v0/b/linkup-31422.appspot.com/o/images%2Fuser_profile_default.png?alt=media&token=c2575581-3695-44fa-a30e-02f795f6f669',
  );
  User logUser = User.loginConstructor(
    email: '',
    password: '',
  );
  User user = User(
    firstName: '',
    lastName: '',
    phoneNumber: '',
    email: '',
    password: '',
    profileImageURL: '',
    token: '',
    applications: [],
    educations: [],
    experiences: [],
    id: '',
    jobs: [],
    posts: [],
    skills: [],
  );
  final storage = const FlutterSecureStorage();

  // Create new user profile
  void create(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseApi/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'firstName': newUser.firstName,
          'lastName': newUser.lastName,
          'phoneNumber': newUser.phoneNumber,
          'password': newUser.password,
          'email': newUser.email,
          'profileImageURL': newUser.profileImageURL,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var authData = User.fromCreateJson(data);
      final token = await storage.read(key: 'authToken');

      if (token != null) {
        await storage.deleteAll();
      }
      await storage.write(key: 'authToken', value: authData.token);
      await storage.write(key: 'userId', value: authData.id);

      // Get user profile
      getProfile(context);

      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Success',
        backgroundColor: colorSuccessLight,
        textColor: colorTextPrimary,
      );
      Navigator.pushNamed(context, '/home');
    }
  }

  // User login
  void login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseApi/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'email': logUser.email,
          'password': logUser.password,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var authData = User.fromJson(data);
      final token = await storage.read(key: 'authToken');

      if (token != null) {
        await storage.deleteAll();
      }
      await storage.write(key: 'authToken', value: authData.token);
      await storage.write(key: 'userId', value: authData.id);

      // Get user profile
      getProfile(context);

      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Login Success',
        backgroundColor: colorSuccessLight,
        textColor: colorTextPrimary,
      );
      Navigator.pushNamed(context, '/home');
    } else {
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Login Failed',
        backgroundColor: colorErrorLight,
        textColor: colorTextPrimary,
      );
    }
  }

  // Get user profile
  Future<User> getProfile(BuildContext context) async {
    final authToken = await storage.read(key: 'authToken');
    final response = await http.get(
      Uri.parse('$baseApi/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      user = User.fromJson(data);
      notifyListeners();
      return user;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: 'Authentication Failed');
      Navigator.pushNamed(context, '/login');
      notifyListeners();
      return null;
    } else {
      Fluttertoast.showToast(msg: 'Server Error');
      notifyListeners();
      return null;
    }
  }

  // Update user profile
  Future<User> updateUser(BuildContext context) async {
    final authToken = await storage.read(key: 'authToken');
    final response = await http.put(
      Uri.parse('$baseApi/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
      body: jsonEncode(
        <String, String>{
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phoneNumber': user.phoneNumber,
          'password': user.password,
          'email': user.email,
          'profileImageURL': user.profileImageURL,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      user = User.fromJson(data);

      // Get updated user profile
      getProfile(context);

      notifyListeners();
      Fluttertoast.showToast(msg: 'Update Success');
      return user;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: 'Authentication Failed');
      notifyListeners();
      return null;
    } else {
      Fluttertoast.showToast(msg: 'Server Error');
      notifyListeners();
      return null;
    }
  }

  void deleteUser(BuildContext context) async {
    var userId = user.id;
    final authToken = await storage.read(key: 'authToken');
    final response = await http.delete(
      Uri.parse('$baseApi/user/remove/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': authToken,
      },
    );

    if (response.statusCode == 200) {
      await storage.deleteAll();
      Navigator.pushNamed(context, '/signup');
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: 'Authentication Failed');
      notifyListeners();
      return null;
    } else {
      Fluttertoast.showToast(msg: 'Server Error');
      notifyListeners();
      return null;
    }
  }
}