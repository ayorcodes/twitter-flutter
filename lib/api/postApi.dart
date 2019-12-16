import 'package:news_app/api/config/apiConfig.dart';
import 'dart:convert';

class PostApi {

  final api = ApiConfig();

  getPosts() async {
    await api.init();
    return await api.$Request().get('posts');
  }

  loadMorePosts(page) async{
    await api.init();
    return await api.$Request().get('posts?page=$page');
  }

  getComments(id) async{
    await api.init();
    return await api.$Request().get("posts/$id/comments");
  }

  addPost(data) async {
    var payload = jsonEncode(data);
    await api.init();
    return await api.$Request().post('posts', data: payload);
  }

  addComment(id, data) async{
    var payload = jsonEncode(data);
    await api.init();
    return await api.$Request().post("posts/$id/comments", data: payload);
  }
}