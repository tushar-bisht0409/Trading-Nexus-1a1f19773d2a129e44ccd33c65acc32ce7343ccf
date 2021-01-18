import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _reftoken;
  Timer _authTimer;

  bool get isAuth {
    return (_token != null);
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      if (_reftoken != null) {
        refreshSession();
        return _token;
      } else {
        return null;
      }
    }
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDURNP8XilsEVmAKFUl-JhjI_OBfypPMr4';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _reftoken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autorefresh();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'reftoken': _reftoken,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      refreshSession();
      return true;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autorefresh();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _reftoken = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //prefs.clear();
  }

  void _autorefresh() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), refreshSession);
  }

  Future<void> refreshSession() async {
    if (_reftoken != null) {
      final url =
          'https://securetoken.googleapis.com/v1/token?key=AIzaSyDURNP8XilsEVmAKFUl-JhjI_OBfypPMr4';
      //$WEB_API_KEY=> You should write your web api key on your firebase project.

      try {
        final response = await http.post(
          url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          //body: json.encode({
          //'grant_type': 'refresh_token',
          //'refresh_token': '$reftoken', // Your refresh token.
          //}),
          // Or try without json.encode.
          // Like this:
          body: {
            'grant_type': 'refresh_token',
            'refresh_token': '$_reftoken',
          },
        );
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
        _token = responseData['id_token'];
        _reftoken =
            responseData['refresh_token']; // Also save your refresh token
        _userId = responseData['user_id'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expires_in'])));
        _autorefresh();

        notifyListeners();

        print(responseData);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'refresh_token': _reftoken,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
      } catch (error) {
        throw error;
      }
    } else {
      _token = null;
    }
  }
}
