import 'dart:convert';

import 'package:http/http.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/models/NewsChannelHeadlinesModel.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/categoriesNewsModel.dart';
class News {

  Future<NewsChannelHeadlinesModel> fetchNewChannelheadlinesApi(String name) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=$name&apiKey=$API_KEY';
    final Response = await http.get(Uri.parse(url));
    if(Response.statusCode == 200){
      final body = json.decode(Response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('error');


    }


  Future<CategoriesNewsModel> fetchCategoryNewsApi(String category) async {
    String url = 'https://newsapi.org/v2/top-headlines?category=$category&apiKey=$API_KEY';
    final Response = await http.get(Uri.parse(url));
    if(Response.statusCode == 200){
      final body = json.decode(Response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('error');


    }

}