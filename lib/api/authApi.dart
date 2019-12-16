import 'dart:convert';
import 'package:news_app/api/config/apiConfig.dart';
class Auth extends ApiConfig{

  final api = ApiConfig();

  Future login(String email, String password) async{
    var payload = jsonEncode({"email": email, "password": password});
    return await api.$LoginRequest().post('auth/login', data: payload);
  }

  Future checkAuth() async {
    await api.init();
    return await api.$Request().post('auth/me');
  }

  Future logout() async{
    return api.$Request().post('auth/logout');
  }



}