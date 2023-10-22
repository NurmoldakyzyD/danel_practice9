import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_danelya9/bloc/bloc_state.dart';
import 'package:flutter_danelya9/main.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  Future<List<Post>> fetchPostsFromApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void fetchPosts() async {
    emit(PostLoading());
    try {
      List<Post> posts = await fetchPostsFromApi();
      emit(PostLoaded(posts));
    } catch (error) {
      emit(PostError("Ошибка загрузки постов"));
    }
  }
}
