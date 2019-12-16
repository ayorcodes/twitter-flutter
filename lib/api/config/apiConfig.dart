import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ApiConfig {

  static const auth = 'Authorization';

  Dio dio = new Dio();
  String token;
  final storage = new FlutterSecureStorage();

  init() async{
    await this.bearerToken();
  }

  $Request() {
    this.dio.options.baseUrl = this.baseUrl().toString();
    this.dio.options.headers = this.setHeaders();
    return this.dio;
  }

  baseUrl() {
    const Server = 'server';
    if (Server == 'local') return 'http://127.0.0.1:8000/api/';

    //return 'http://192.168.100.157:8000/api/';
    //return 'http://192.168.1.29:8000/api/';
    return 'http://192.168.43.103:8000/api/';
  }

  setHeaders() {
    Map<String, dynamic> header = { "Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer ${this.token}"};
    //print("header $header");
    return header;
  }

  $LoginRequest() {
    this.dio.options.baseUrl = this.baseUrl().toString();
    return this.dio;
  }

  bearerToken() async{
    //print("start");
    var token = await this.storage.read(key: "token");
    this.token = token;
    //print("finish");
  }

  setToken(String token) async{
    await this.storage.write(key: "token", value: token);
    await this.init();
  }

  setUser(data) async{
    await this.storage.write(key: "user", value: data);
  }

  deleteToken() async{
    this.token = '';
    await this.storage.delete(key: "token");
  }
}