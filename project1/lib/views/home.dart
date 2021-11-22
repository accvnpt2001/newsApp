import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project1/helper/data.dart';
import 'package:project1/helper/news.dart';
import 'package:project1/models/article_model.dart';
import 'package:project1/models/category_model.dart';
import 'package:project1/views/category_news.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("News", style: TextStyle(
          color: Colors.blue,
        ),),
        centerTitle: true,
        elevation: 0.0,
      ),
      body:_loading ? const Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
             children: [
              //Categories
              SizedBox(
                height: 80,
                child: ListView.builder(
                  itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                    return CategoryTitle(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                    }),
              ),

              //Blogs
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: articles.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return BlogTitle(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url,
                      );
                    }),
              ),
            ],
            ),
           ),
      ),
    );
  }
}

class CategoryTitle extends StatefulWidget {

  final String imageUrl, categoryName;
  const CategoryTitle({required this.imageUrl, required this.categoryName});

  @override
  State<CategoryTitle> createState() => _CategoryTitleState();
}

class _CategoryTitleState extends State<CategoryTitle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: widget.categoryName.toLowerCase(),
            ) ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl, width: 160, height: 80, fit: BoxFit.cover,)
            ),
            Container(
              alignment: AlignmentDirectional.center,
              width: 160,
              height: 80,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(widget.categoryName, style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),),
            )
          ],
        ),
      ),
    );
  }
}