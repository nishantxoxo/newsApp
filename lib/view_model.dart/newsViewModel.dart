import 'package:http/http.dart';
import 'package:newsapp/models/NewsChannelHeadlinesModel.dart';
import 'package:newsapp/repository/news.dart';

class Newsviewmodel {
  final _rep = News();

  Future<NewsChannelHeadlinesModel> fetchNewChannelheadlinesApi() async{

    final Response = await  _rep.fetchNewChannelheadlinesApi();
    return Response;
  }
}