import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/widget/tab_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cateogry_page.dart';

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

class _MainScreenState extends State<MainScreen> {
  SharedPreferences sharedPreferences;
  List<NavItem>NavItemList=[
    NavItem(name: 'الرئيسيه',navIcon:Icons.home ),
    NavItem(name: 'الاقسام',navIcon:Icons.apps,isExpanded: true),
    NavItem(name: 'حسابي',navIcon:Icons.person ),
    NavItem(name: 'اعلاناتي',navIcon:Icons.announcement),
    NavItem(name: 'المفضله',navIcon:Icons.favorite),
  NavItem(name: 'الاعدادات',navIcon:Icons.settings)
  ];
  List<NavItem>depratmentNavList=[
    NavItem(name: 'اجهزه الكترونيه',navIcon:Icons.settings ),
    NavItem(name: 'سيارات وقطع غيار',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
  ];

  void _selectedTab(int index) {

  }
  int _navSelectedIndex=0;

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

      floatingActionButton:   Container(
        height: 100,
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
           Text('اضافه اعلان',style: TextStyle(color: Colors.white),)
          ],)
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'A',
        color: Colors.grey,
        selectedColor: Theme.of(context).accentColor,
         onTabSelected:_selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.person, text: 'حسابي'),
          FABBottomAppBarItem(iconData: Icons.announcement, text: 'العروض'),
          FABBottomAppBarItem(iconData: Icons.favorite, text: 'المفضله'),
          FABBottomAppBarItem(iconData: Icons.home, text: 'الرئيسيه'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,



      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        title: Text("الرئيسيه",style: TextStyles.appBarTitle,),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu,color: Colors.black,),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
        ],
        leading: Icon(Icons.search,color: Colors.black,),


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
              child: ListView(children:
              drawerOptions

                ,),
            ),//listview

          Container(
            alignment: Alignment.center,
            height: 60,
            color: Theme.of(context).accentColor,
            child: Text('تسجيل الخروج',style: TextStyle(color: Colors.white),),
          )

          ],

        ),//coulmn



      ),

      body: _getDrawerItemWidget(_navSelectedIndex),
    );//scaffold
  }



  _onSelectItem(int index) {
    setState(() => _navSelectedIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }



  Widget createNavItem(NavItem nav,int index){
    if(nav.isExpanded){
       List<Widget>subItemlist=[];
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
      );

    }else {
      return ListTile(trailing: Icon(nav.navIcon),
        title: Text(nav.name, textAlign: TextAlign.end,),
        selected: index==_navSelectedIndex,
        onTap:()=> _onSelectItem(index),

      );
    }
  }



  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return  BlocProvider(
            bloc: CategoryBloc(),child:CategoryListFragment());
      case 1:
        return new CategoryListFragment();
      case 2:
        return new CategoryListFragment();

      default:
        return new Text("Error");
    }
  }

}
