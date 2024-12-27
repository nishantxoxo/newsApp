import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/NewsChannelHeadlinesModel.dart';
import 'package:newsapp/models/categoriesNewsModel.dart';
import 'package:newsapp/screens/categoriesScreen.dart';
import 'package:newsapp/screens/newsDetailScreen.dart';
import 'package:newsapp/view_model.dart/newsViewModel.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

enum FilterList { bbcnews, abcnews, buzzfeed }

class _HomescreenState extends State<Homescreen> {
  Newsviewmodel newsviewmodel = Newsviewmodel();
  FilterList? selectedmenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Categoriesscreen(),
                  ));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: 30,
              width: 30,
            )),
        title: Text(
          'news',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            onSelected: (FilterList value) {
              if (FilterList.bbcnews.name == value.name) {
                setState(() {
                name = 'bbc-news';
                  
                });
              }
              if (FilterList.abcnews.name == value.name) {
                setState(() {
                name = 'abc-news';
                  
                });
              }
              if (FilterList.buzzfeed.name == value.name) {
                setState(() {
                name = 'buzzfeed';
                  
                });
              }

            },
            icon: Icon(Icons.more_vert),
            initialValue: selectedmenu,
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcnews,
                child: Text('BBC news'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.abcnews,
                child: Text('abc news'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.buzzfeed,
                child: Text('buzzfeed'),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

      
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsviewmodel.fetchNewChannelheadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Newsdetailscreen(
                                      newsImage: snapshot
                                          .data!.articles![index].urlToImage,
                                      newsTitle: snapshot
                                          .data!.articles![index].title,
                                      newsDate: snapshot
                                          .data!.articles![index].publishedAt,
                                      newsAuthor: snapshot
                                          .data!.articles![index].author,
                                      newsDesc: snapshot
                                          .data!.articles![index].description,
                                      newsContent: snapshot
                                          .data!.articles![index].content,
                                      newsSource: snapshot
                                          .data!.articles![index].source!.name),
                                ));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: height * 0.02,),
                                height: height * 0.6,
                                width: width * 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline ,color: Colors.red,),
                                      placeholder: (context, url) =>
                                          SpinKitFadingCircle(
                                            color: Colors.amber,
                                            size: 50,
                                          ),
                                      fit: BoxFit.cover,
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString()),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.6,
                                          child: Text(
                                            snapshot.data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: width * 0.6,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          FutureBuilder<CategoriesNewsModel>(
            future: newsviewmodel.fetchCategoryNewsApi('general'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.articles!.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(snapshot
                        .data!.articles![index].publishedAt
                        .toString());
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Newsdetailscreen(
                                    newsImage: snapshot
                                        .data!.articles![index].urlToImage,
                                    newsTitle: snapshot
                                        .data!.articles![index].title,
                                    newsDate: snapshot
                                        .data!.articles![index].publishedAt,
                                    newsAuthor: snapshot
                                        .data!.articles![index].author,
                                    newsDesc: snapshot
                                        .data!.articles![index].description,
                                    newsContent: snapshot
                                        .data!.articles![index].content,
                                    newsSource: snapshot
                                        .data!.articles![index].source!.name),
                              ));
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) => Icon(Icons.error_outline ,color: Colors.red,),
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) =>
                                      SpinKitFadingCircle(
                                        color: Colors.amber,
                                        size: 50,
                                      ),
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString()),
                                  
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(left: 15),
                              height: height * .18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Spacer(),
                                  Text(
                                        snapshot
                                            .data!.articles![index].source!.name
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        format.format(dateTime),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),  ),
    );
  }
}

