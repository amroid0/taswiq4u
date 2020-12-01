import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olx/data/bloc/NavigationBloc.dart';
import 'package:olx/data/bloc/ads_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/favroite_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/profile_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/pages/add_ads_page.dart';
import 'package:olx/pages/favroite_page.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/offer_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/profile_page.dart';
import 'package:olx/pages/search_delegate_page.dart';
import 'package:olx/pages/search_key_page.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/tab_item.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cateogry_page.dart';
import 'my_ads_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class NavItem{
  String name;
  IconData navIcon;
  bool isExpanded=false;
  NavItem({this.name,this.navIcon,this.isExpanded=false}){}
}

List<FABBottomAppBarItem> bottomItems= [
  FABBottomAppBarItem(iconData: Icons.person, text:allTranslations.text('account')),
  FABBottomAppBarItem(iconData: Icons.announcement, text: allTranslations.text('offers')),
  FABBottomAppBarItem(iconData: Icons.favorite, text: allTranslations.text('favroite')),
  FABBottomAppBarItem(iconData: Icons.home, text: allTranslations.text('home')),
];



class _MainScreenState extends State<MainScreen> {
  SharedPreferences sharedPreferences;
  NaviagtionBloc bloc;
  List<NavItem>NavItemList=[
    NavItem(name: allTranslations.text('home'),navIcon:Icons.home ),
    NavItem(name: "تسجيل دخول",navIcon:Icons.login),
    NavItem(name: allTranslations.text('account'),navIcon:Icons.person ),
    NavItem(name: allTranslations.text('my_ads'),navIcon:Icons.announcement),
    NavItem(name:allTranslations.text('favroite'),navIcon:Icons.favorite),
  NavItem(name:allTranslations.text('settings'),navIcon:Icons.settings)
  ];
/*
  List<NavItem>depratmentNavList=[
    NavItem(name: 'اجهزه الكترونيه',navIcon:Icons.settings ),
    NavItem(name: 'سيارات وقطع غيار',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
  ];
*/

  void _selectedTab(int index) {
    if(allTranslations.isEnglish){
      if(index==2){

        bloc.navigateToScreen(NavigationScreen.OFFER);

      }else if(index==3){


        bloc.navigateToScreen(NavigationScreen.PRFOILE);

      }else if(index==1){
        bloc.navigateToScreen(NavigationScreen.FAVROITE);
      }
      else if(index==0){
        bloc.navigateToScreen(NavigationScreen.HOME);
      }
    }else{
    if(index==1){

      bloc.navigateToScreen(NavigationScreen.OFFER);


    }else if(index==2){

      bloc.navigateToScreen(NavigationScreen.FAVROITE);

    }else if(index==0){

      bloc.navigateToScreen(NavigationScreen.PRFOILE);


    }
    else if(index==3){

      bloc.navigateToScreen(NavigationScreen.HOME);


    }

    }
  }
  int _navSelectedIndex=0;
  Widget appBarTitle =  Text(allTranslations.text('home'),style:TextStyles.appBarTitle ,);
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController searchController=null;

@override
  void initState() {
    // TODO: implement initState
  bloc=new NaviagtionBloc();
   searchController = new TextEditingController();
   if(allTranslations.isEnglish){
     bottomItems.reversed.toList();
   }
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    List<Widget> drawerOptions = [];

    for (var i = 0; i < NavItemList.length; i++) {
      var d = NavItemList[i];
      drawerOptions.add(
          createNavItem(d, i)
      );
    }
    return Scaffold(
      key: _scaffoldKey,

      floatingActionButton:   InkWell(
        onTap: ()=>{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAdvertisment()),
          )
        },
        child: Container(
          height: 60,
            width: 70,
            decoration:  BoxDecoration(

                color: Colors.green,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              Expanded(child: Icon(Icons.add,color: Colors.white,))
             ,
             Text(allTranslations.text('ads_add'),style: TextStyle(color: Colors.white),)
            ],)
            ,
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: Theme.of(context).accentColor,
         onTabSelected:_selectedTab,
        items:bottomItems,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        title: appBarTitle,
        centerTitle: true,
          leading: IconButton(icon: actionIcon,color: Colors.black,
            onPressed:
                  () => showSearch(
                context: context,
                delegate: DummyDelegate(),
              )
           ,),

          actions: <Widget>[

            IconButton(icon: Icon(Icons.menu,color: Colors.black,),
                onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
            ]


      ),//appbar
      endDrawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.topLeft,
                child: Icon(Icons.notifications_paused),
                decoration: BoxDecoration(
                    image:DecorationImage(
                        image: AssetImage('images/logo.png'),fit: BoxFit.cover)),

              ),//container
              decoration: BoxDecoration(color: AppColors.appBackground),
            ),

            Expanded(
              child: StreamBuilder<bool>(
                initialData:BlocProvider.of<LoginBloc>(context).isLogged ,
                stream: BlocProvider.of<LoginBloc>(context).Sessionstream,
                builder: (context, snapshot) {
                  if(snapshot.hasData&&snapshot.data)
                  return ListView(children:
                  drawerOptions

                    ,);
                  else{
                  drawerOptions.removeAt(1);
                      return ListView(children:
                  drawerOptions

                    ,);
                  }
                }
              ),
            ),//listview

          GestureDetector(
            onTap: (){

           Alert(context: context,title: allTranslations.text('logout')
           ,desc: allTranslations.text('logout_msg')
               ,type: AlertType.warning,
             buttons: [
               DialogButton(
                 child: Text(
                   allTranslations.text('ok'),
                   style: TextStyle(color: Colors.white, fontSize: 20),
                 ),
                 onPressed: () {
                   preferences.logout();
                   Navigator.pushAndRemoveUntil(
                       context,
                       PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                           Animation secondaryAnimation) {
                         return ParentAuthPage();
                       }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                           Animation<double> secondaryAnimation, Widget child) {
                         return new SlideTransition(
                           position: new Tween<Offset>(
                             begin: const Offset(1.0, 0.0),
                             end: Offset.zero,
                           ).animate(animation),
                           child: child,
                         );
                       }),
                           (Route route) => false);
                 },
                 width: 120,
               )
               ,               DialogButton(
                 child: Text(
                   allTranslations.text('cancel'),
                   style: TextStyle(color: Colors.white, fontSize: 20),
                 ),
                 onPressed: () => Navigator.pop(context),
                 width: 120,
               )
             ],
           ).show();


            },
            child: StreamBuilder<bool>(
              initialData:BlocProvider.of<LoginBloc>(context).isLogged ,
              stream: BlocProvider.of<LoginBloc>(context).Sessionstream,
              builder: (context, snapshot) {
                if(snapshot.hasData&&snapshot.data)
                return Container(
                  alignment: Alignment.center,
                  height: 60,
                  color: Theme.of(context).accentColor,
                  child: Text(allTranslations.text('logout'),style: TextStyle(color: Colors.white),),
                );
                else return Container();
              }
            ),
          )

          ],

        ),//coulmn



      ),

      body:StreamBuilder<NavigationScreen>(
        initialData: NavigationScreen.HOME,
        stream: bloc.stream,
        builder: (context,snap){
          return  _getDrawerItemWidget(snap.data);

        },
      )


    );//scaffold
  }



  _onSelectItem(int index) {
  //  setState(() => _navSelectedIndex = index);

    if(index==2){
     bloc.navigateToScreen(NavigationScreen.MYADS);
    }else if(index==1){

      bloc.navigateToScreen(NavigationScreen.PRFOILE);


    }else if(index==3){
      bloc.navigateToScreen(NavigationScreen.FAVROITE);

    }
    else if(index==0){
      bloc.navigateToScreen(NavigationScreen.HOME);

    }


  }



  Widget createNavItem(NavItem nav,int index){
    if(nav.isExpanded){
     /*  List<Widget>subItemlist=[];
      for (var i = 0; i < depratmentNavList.length; i++) {
        var d = depratmentNavList[i];
        subItemlist.add(
            createNavItem(d, i)
        );
      }
      return ExpansionTile(trailing: Icon(nav.navIcon),leading: Icon(Icons.keyboard_arrow_down),
        title: Text(nav.name, textAlign: TextAlign.end,
        ),
         children:subItemlist,
      );*/

    }else {
      return ListTile(trailing: Icon(nav.navIcon),
        title: Text(nav.name, textAlign: TextAlign.end,),
        selected: index==_navSelectedIndex,
        onTap:()=> _onSelectItem(index),

      );
    }
  }



  _getDrawerItemWidget(NavigationScreen screen) {
    switch (screen) {
      case NavigationScreen.HOME:

        return  CategoryListFragment();

        case NavigationScreen.FAVROITE:
          if(BlocProvider.of<LoginBloc>(context).isLogged)
        return new FavroitePage();
          else
            return
                Navigator.push(context, MaterialPageRoute(builder:(context) => ParentAuthPage()));

        case NavigationScreen.OFFER:
        return BlocProvider(bloc:CategoryBloc(),child: new OfferPage());

      case NavigationScreen.PRFOILE:
        return new ProfilePage();

      case NavigationScreen.MYADS:
        return new MyAdsPage();

      default:
        return new Text("Error");
    }
  }

}
