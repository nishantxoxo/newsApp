import 'dart:convert';

import 'package:http/http.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/models/NewsChannelHeadlinesModel.dart';
import 'package:http/http.dart' as http;
class News {

  Future<NewsChannelHeadlinesModel> fetchNewChannelheadlinesApi() async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$API_KEY';
    final Response = await http.get(Uri.parse(url));
    if(Response.statusCode == 200){
      final body = json.decode(Response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('error');


    }

}