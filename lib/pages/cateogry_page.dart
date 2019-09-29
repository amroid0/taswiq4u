import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/pages/search_page.dart';
import 'package:olx/utils/Theme.dart';

class CategoryListFragment extends StatefulWidget {
  CategoryListFragment() : super();

  final String title = "Carousel Demo";

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CategoryListFragment> {
  var  _bloc;
  List<CateogryEntity>totalCateogryList;

  //
  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<CategoryBloc>(context);
    _bloc.submitQuery("");
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){
        if(_bloc.isStackIsEmpty()){
          Navigator.pop(context);

        }else {
          _bloc.removeCateogryFromStack();
        }
      },
      child: Container(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              carouselSlider = CarouselSlider(

                height: MediaQuery.of(context).size.height*.25,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                pauseAutoPlayOnTouch: Duration(seconds: 10),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.appBackground,
                        ),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgList, (index, url) {
                  return Container(
                    width: 7.0,
                    height: 7.0,
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ?Theme.of(context).accentColor: Colors.black26 ,
                    ),
                  );
                }),
              ),

              Expanded(
                child: StreamBuilder<List<CateogryEntity>>(
                  stream: _bloc.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    }

                    return _buildCategoryList(snapshot.data);
                  }
                ),
              )




            ],
          ),

      ),
    );
  }

  Widget _buildCategoryList(List<CateogryEntity> category){
    return ListView.builder(
      itemCount: category.length,
      itemBuilder: (BuildContext context,int index){


        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: new InkWell(
            onTap: (){
              if(category[index].hasSub){
                _bloc.addCateogryToStack(category[index].subCategories);
              }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlocProvider(bloc: AdsBloc(),child:SearchAnnounceListScreen(),)),
              );
              }

            },
            child: new Card(
              child: new SizedBox(
                height: 60.0,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Expanded(
                      child: new ListTile(
                        title: new Text(category[index].name,textAlign:TextAlign.end),
                        subtitle: Text(category[index].arabicDescription,textAlign: TextAlign.end,),
                        leading: Icon(Icons.keyboard_arrow_left,color: Colors.black,),
                      ),
                    ),
                    new Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,


                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,)
                          ]),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.directions_car,color: Colors.white,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );


      },
    );


  }


  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}