import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/pages/ads_list_page.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';

class CategoryListDialog extends StatefulWidget {
  CategoryListDialog() : super();

  final String title = "Carousel Demo";

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CategoryListDialog> {
  var  _bloc;
  List<CateogryEntity>totalCateogryList;

  //
  int _current = 0;


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
             /*   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlocProvider(bloc: AdsBloc(),child:SearchAnnounceListScreen(),)),
                );*/
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
                        subtitle: Text(allTranslations.isEnglish?category[index].englishDescription:category[index].arabicDescription,textAlign: TextAlign.end,),
                        leading: Icon(allTranslations.isEnglish?Icons.keyboard_arrow_right:Icons.keyboard_arrow_left,color: Colors.black,),
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
                      child: Icon(Icons.image,color: Colors.white,),
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

}