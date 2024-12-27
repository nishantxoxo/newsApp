import 'package:http/http.dart';
import 'package:newsapp/models/NewsChannelHeadlinesModel.dart';
import 'package:newsapp/models/categoriesNewsModel.dart';
import 'package:newsapp/repository/news.dart';

class Newsviewmodel {
  final _rep = News();

  Future<NewsChannelHeadlinesModel> fetchNewChannelheadlinesApi(String name) async{

    final Response = await  _rep.fetchNewChannelheadlinesApi(name);
    return Response;
  }

  Future<CategoriesNewsModel> fetchCategoryNewsApi(String name) async{

    final Response = await  _rep.fetchCategoryNewsApi(name);
    return Response;}

}