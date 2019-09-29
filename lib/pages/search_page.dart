import 'package:flutter/material.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/model/ads_entity.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/widget/favroite_widget.dart';

class SearchAnnounceListScreen extends StatefulWidget {
  @override
  _SearchAnnounceListScreenState createState() => _SearchAnnounceListScreenState();
}

class _SearchAnnounceListScreenState extends State<SearchAnnounceListScreen> {
  int _sortSelectedValue=1;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AdsBloc>(context).submitQuery(1);
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        title: Text("السيارات",style: TextStyles.appBarTitle,),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward,color: Colors.black,),
              onPressed: () => {}),
        ],
        leading: Icon(Icons.search,color: Colors.black,),
        elevation: 0,


      ),//appbar
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('فرز بواسطه'),
            InkWell(
              onTap: (){},
              child: Container(

                width: 36
                  ,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                      ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                  child: Icon(Icons.filter), ),
            ),

              Text('ترتيب'),
              InkWell(
                onTap: (){
                  _newSortModalBottomSheet(context);

                },
                child: Container(

                  width: 36
                  ,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)
                      ,boxShadow:[ BoxShadow(color: Colors.black12,blurRadius: 10)],color: Colors.white),
                  child: Icon(Icons.sort_by_alpha), ),
              ),

        ],),



          Expanded(
            child: StreamBuilder(
              stream: BlocProvider.of<AdsBloc>(context).stream,
              builder:(context,snap){
                if (!snap.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.deepOrangeAccent,
                      strokeWidth: 5.0,
                    ),
                  );
                }
                 return _buildAdsList(snap.data);




              },
            ),
          )

        ],
      ),


    );

  }
  Widget _buildAdsList(AdsEntity ads){
    return ListView.builder(
      itemCount: ads.advertisementList.list.length+ads.commercialAdsList.length,
      itemBuilder: (BuildContext context,int index){
         if(index!=0&& index%6==0){
              int comIndex=(index/6-1).toInt();
              String commercialAdsItem="http://www.image.com";
              if(ads.commercialAdsList.isNotEmpty&&comIndex<ads.commercialAdsList.length){
                      commercialAdsItem=ads.commercialAdsList[comIndex].Link;
              }
           return Container(
             width: MediaQuery.of(context).size.width,
             height: 100,
             margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
             decoration: BoxDecoration(
               color:Colors.black12,
             ),
             child: Image.network(
               commercialAdsItem,
               fit: BoxFit.fill,

             ),
           );

         }else {
           return Container(

             margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
             child: new InkWell(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => SearchAnnounceListScreen()),
                 );
               },
               child: new Card(
                 elevation: 4,
                 child: new SizedBox(
                   height: 96.0,
                   child: new Row(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: <Widget>[
                       InkWell(

                         onTap: () {},
                         child: Container(
                             margin: EdgeInsets.only(left: 4),

                             alignment: Alignment.center,
                             color: Colors.white,
                             child: FavroiteWidget(


                             )),
                       ),


                       new Expanded(
                           child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 4),
                             child: Column(

                               crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 Text(ads.advertisementList.list[index]
                                     .EnglishTitle),
                                 Text(ads.advertisementList.list[index]
                                     .ArabicDescription,
                                   overflow: TextOverflow.fade,
                                   maxLines: 1,

                                   style: TextStyle(color: Theme
                                       .of(context)
                                       .accentColor),),
                                 Divider(height: 1,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.end,

                                   children: <Widget>[
                                     Text(ads.advertisementList.list[index]
                                         .CityNameEnglish),
                                     Icon(Icons.pin_drop, size: 16),

                                   ],),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                   children: <Widget>[

                                     Text(ads.advertisementList.list[index]
                                         .CreationTime.toIso8601String()),
                                     Icon(Icons.update, size: 16,),

                                   ],),


                               ],


                             ),
                           )


                       ),
                       new Container(
                         width: 100,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(
                               topRight: Radius.circular(4),
                               bottomRight: Radius.circular(4)),
                           color: Theme
                               .of(context)
                               .accentColor,

                         ),
                         alignment: Alignment.center,
                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                         child: Icon(
                           Icons.directions_car, color: Colors.white,),
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           );
         }

      },
    );


  }
void _OnSelectSort(int val){
  _sortSelectedValue=val;
  BlocProvider.of<AdsBloc>(context).submitQuery(val);

  Navigator.of(context).pop();
}
  void _newSortModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[


            Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 1,
                    groupValue: _sortSelectedValue,
                    title: Text(" الاعلي سعرا",style: TextStyle(color: Colors.black),),
                    onChanged: (val) {
                      _OnSelectSort(val);
                      },

                    selected: true,
                  ),
                ),
                Divider(height: 2,color: Colors.grey,),
            Directionality(textDirection: TextDirection.rtl,

                  child: RadioListTile(
                    value: 2,
                    groupValue: _sortSelectedValue,
                    title: Text(" الاقل سعرا",style: TextStyle(color: Colors.black)),
                    onChanged: (val) {
                      _OnSelectSort(val);

                    },

                    selected: true,

                  ),
                ),
            Divider(height: 2,color: Colors.grey,),
                Directionality(textDirection: TextDirection.rtl,
                  child: RadioListTile(
                    value: 3,
                    groupValue: _sortSelectedValue,
                    title: Text("المضاف مؤخرا",style: TextStyle(color: Colors.black)),
                    onChanged: (val) {
                      _OnSelectSort(val);
                    },

                    selected: true,
                  ),
                ),

              ],
            ),
          );
        }
    );
  }
}
