import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/categoriesNewsModel.dart';
import 'package:newsapp/screens/newsDetailScreen.dart';
import 'package:newsapp/view_model.dart/newsViewModel.dart';

class Categoriesscreen extends StatefulWidget {
  const Categoriesscreen({super.key});

  @override
  State<Categoriesscreen> createState() => _CategoriesscreenState();
}

class _CategoriesscreenState extends State<Categoriesscreen> {
  Newsviewmodel newsviewmodel = Newsviewmodel();

  final format = DateFormat('MMMM dd, yyyy');
  String categoryname = 'general';

  List<String> buttonCategories = [
    'general',
    'health',
    'science',
    'sports',
    'business',
    'technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buttonCategories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    categoryname = buttonCategories[index];
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5), // Add horizontal padding between buttons
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8), // Padding inside the button
                      decoration: BoxDecoration(
                        color: categoryname == buttonCategories[index]
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      alignment: Alignment
                          .center, // Center the text within the container
                      child: Text(
                        buttonCategories[index].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsviewmodel.fetchCategoryNewsApi(categoryname),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
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
          ),
        ],
      ),
    );
  }
}
