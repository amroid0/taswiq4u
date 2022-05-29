import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx/data/bloc/NavigationBloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/languge_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/pages/add_ads_page.dart';
import 'package:olx/pages/favroite_page.dart';
import 'package:olx/pages/general_settings.dart';
import 'package:olx/pages/offer_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/profile_page.dart';
import 'package:olx/pages/search_ads_page.dart';
import 'package:olx/utils/Constants.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/custom_web_view.dart';
import 'package:olx/widget/tab_item.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cateogry_page.dart';
import 'my_ads_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class NavItem {
  String name;
  IconData navIcon;
  bool isExpanded = false;

  NavItem({this.name, this.navIcon, this.isExpanded = false}) {}
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences sharedPreferences;
  NaviagtionBloc bloc;
  String userName = "";
  int userCountryId;
  bool isFirst;
  String cId;

  int countryId;

  StreamController _controller = StreamController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  CategoryBloc _cateogyBloc;

/*
  List<NavItem>depratmentNavList=[
    NavItem(name: 'اجهزه الكترونيه',navIcon:Icons.settings ),
    NavItem(name: 'سيارات وقطع غيار',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
    NavItem(name: 'الاعدادات',navIcon:Icons.settings ),
  ];
*/
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void _selectedTab(int index) {
    if (index == 1) {
      bloc.navigateToScreen(NavigationScreen.OFFER);
    } else if (index == 2) {
      bloc.navigateToScreen(NavigationScreen.FAVROITE);
    } else if (index == 0) {
      bloc.navigateToScreen(NavigationScreen.PRFOILE);
    } else if (index == 3) {
      bloc.navigateToScreen(NavigationScreen.HOME);
    }
  }

  int _navSelectedIndex = 0;
  Widget appBarTitle = Text(
    allTranslations.text('home'),
    style: TextStyles.appBarTitle,
  );
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController searchController = null;

  @override
  void initState() {
    // TODO: implement initState
    // getUserName();
    bloc = new NaviagtionBloc();
    _cateogyBloc = CategoryBloc();
    searchController = new TextEditingController();

    bloc.stream.listen((data) async {
      if (data == NavigationScreen.FAVROITE ||
          data == NavigationScreen.PRFOILE ||
          data == NavigationScreen.MYADS) {
        if (!BlocProvider.of<LoginBloc>(context).isLogged())
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ParentAuthPage(
                        login: 1,
                      )),
              (Route<dynamic> route) => false);
      } else if (data == NavigationScreen.CONTACT_US) {
        String url = await APIConstants.getContactUrl();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('contact_us'),
                  selectedUrl: url,
                )));
      } else if (data == NavigationScreen.POLICY) {
        String url = await APIConstants.getPolicyUrl();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('policy'),
                  selectedUrl: url,
                )));
      } else if (data == NavigationScreen.ABOUT) {
        String url = await APIConstants.getAboutUsUrl();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('about_us'),
                  selectedUrl: url,
                )));
      } else if (data == NavigationScreen.RuLES) {
        String url = await APIConstants.getRuleUrl();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('rules'),
                  selectedUrl: url,
                )));
      } else if (data == NavigationScreen.FAQ) {
        String url = await APIConstants.getFAQUsUrl();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('questions'),
                  selectedUrl: url,
                )));
      } else if (data == NavigationScreen.SAFETY) {
        String url = await APIConstants.getSafetyUsUrl();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MyWebView(
                  title: allTranslations.text('safety'),
                  selectedUrl: url,
                )));
      }
    });
    setIsFirst();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    getCountryId();
    List<FABBottomAppBarItem> bottomItems = [
      FABBottomAppBarItem(
          iconData: Icons.person, text: allTranslations.text('account')),
      FABBottomAppBarItem(
          iconData: Icons.announcement, text: allTranslations.text('offers')),
      FABBottomAppBarItem(
          iconData: Icons.favorite, text: allTranslations.text('favroite')),
      FABBottomAppBarItem(
          iconData: Icons.home, text: allTranslations.text('home')),
    ];
    if (allTranslations.isEnglish) {
      bottomItems.reversed.toList();
    }
    List<Widget> drawerOptions = [];

    List<NavItem> NavItemList = [
      NavItem(name: allTranslations.text('home'), navIcon: Icons.home),
      NavItem(name: allTranslations.text('account'), navIcon: Icons.person),
      NavItem(
          name: allTranslations.text('my_ads'), navIcon: Icons.announcement),
      NavItem(name: allTranslations.text('favroite'), navIcon: Icons.favorite),
      NavItem(name: allTranslations.text('settings'), navIcon: Icons.settings),
      NavItem(
          name: allTranslations.text('links'),
          navIcon: FontAwesomeIcons.link,
          isExpanded: true),
      // NavItem(name:allTranslations.text('rules'),navIcon:Icons.book),
      // NavItem(name:allTranslations.text('about_us'),navIcon:Icons.article),
      // NavItem(name:allTranslations.text('questions'),navIcon:Icons.question_answer),
      // NavItem(name:allTranslations.text('contact_us'),navIcon:Icons.call)
    ];
    for (var i = 0; i < NavItemList.length; i++) {
      var d = NavItemList[i];
      drawerOptions.add(
        createNavItem(d, i),
      );
    }
    drawerOptions.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(FontAwesomeIcons.facebook),
          color: Colors.blue,
          onPressed: () => _openSocail(1),
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.instagram),
          color: Colors.purpleAccent,
          onPressed: () => _openSocail(3),
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.twitter),
          color: Colors.lightBlueAccent,
          onPressed: () => _openSocail(2),
        ),
      ],
    ));
    return BlocProvider(
      bloc: _cateogyBloc,
      child: StreamBuilder(
        stream: BlocProvider.of<TranslationsBloc>(context).currentLanguage,
        builder: (context, snap) {
          return Scaffold(
              key: _scaffoldKey,
              bottomNavigationBar:
                  Stack(alignment: new FractionalOffset(.5, 1.0), children: [
                FABBottomAppBar(
                  color: Colors.grey,
                  selectedColor: Theme.of(context).accentColor,
                  onTabSelected: _selectedTab,
                  items: bottomItems,
                ),
                InkWell(
                  onTap: () => {
                    if (BlocProvider.of<LoginBloc>(context).isLogged() &&
                        countryId == userCountryId)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAdvertisment()),
                        )
                      }
                    else if (BlocProvider.of<LoginBloc>(context).isLogged() &&
                        countryId != userCountryId)
                      {
                        Alert(
                          context: context,
                          title: ('warning'),
                          desc: ('please choose correct county'),
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                              child: Text(
                                ('ok'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show(),
                      }
                    else
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ParentAuthPage(
                                    login: 1,
                                  )),
                          (Route<dynamic> route) => false)
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 36,
                        ),
                        Text(
                          allTranslations.text('ads_add'),
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              appBar: AppBar(
                  backgroundColor: AppColors.appBackground,
                  title: StreamBuilder<NavigationScreen>(
                      stream: bloc.stream,
                      builder: (context, snap) {
                        String title = allTranslations.text('home');
                        switch (snap.data) {
                          case NavigationScreen.HOME:
                            title = allTranslations.text('home');
                            break;

                          case NavigationScreen.FAVROITE:
                            if (BlocProvider.of<LoginBloc>(context).isLogged())
                              title = allTranslations.text('favroite');
                            break;

                          case NavigationScreen.OFFER:
                            title = allTranslations.text('offers');
                            break;
                          case NavigationScreen.PRFOILE:
                            if (BlocProvider.of<LoginBloc>(context).isLogged())
                              title = allTranslations.text('account');
                            break;

                          case NavigationScreen.MYADS:
                            if (BlocProvider.of<LoginBloc>(context).isLogged())
                              title = allTranslations.text('my_ads');
                            break;
                          case NavigationScreen.SETTINGS:
                            title = allTranslations.text('settings');
                            break;

                          default:
                            title = allTranslations.text('home');
                        }
                        return Text(
                          title,
                          style: TextStyles.appBarTitle,
                        );
                      }),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      }),
                  actions: <Widget>[
                    IconButton(
                      icon: actionIcon,
                      color: Colors.black,
                      onPressed: () => showSearch(
                        context: context,
                        delegate: DummyDelegate(),
                      ),
                    ),
                  ]),
              //appbar
              endDrawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DrawerHeader(
                      child: StreamBuilder<bool>(
                          initialData:
                              BlocProvider.of<LoginBloc>(context).isLogged(),
                          stream:
                              BlocProvider.of<LoginBloc>(context).Sessionstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // getUserName();
                              return Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Icon(Icons.notifications_paused),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        LoginBloc.nameLogin != null ||
                                                LoginBloc.nameLogin != "null"
                                            ? LoginBloc.nameLogin
                                            : userName,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: AppColors.validValueColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                alignment: Alignment.topLeft,
                                child: Icon(Icons.notifications_paused),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/logo.png'),
                                        fit: BoxFit.cover)),
                              );
                            }
                          }),
                      //container
                      decoration: BoxDecoration(color: AppColors.appBackground),
                    ),

                    StreamBuilder<bool>(
                        initialData:
                            BlocProvider.of<LoginBloc>(context).isLogged(),
                        stream:
                            BlocProvider.of<LoginBloc>(context).Sessionstream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            child: Visibility(
                              visible: snapshot.hasData ? !snapshot.data : true,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.green)),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ParentAuthPage(
                                                login: 1,
                                              )),
                                      (Route<dynamic> route) => false);
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text(
                                    allTranslations
                                        .text('sign_in_up')
                                        .toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          );
                        }),

                    Expanded(
                      child: ListView(children: drawerOptions),
                    ), //listview

                    GestureDetector(
                      onTap: () {
                        Alert(
                          context: context,
                          title: allTranslations.text('logout'),
                          desc: allTranslations.text('logout_msg'),
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                              child: Text(
                                allTranslations.text('ok'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                BlocProvider.of<LoginBloc>(context).logout();
                                LoginBloc.nameLogin = "null";
                              },
                              width: 120,
                            ),
                            DialogButton(
                              child: Text(
                                allTranslations.text('cancel'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      },
                      child: StreamBuilder<bool>(
                          initialData:
                              BlocProvider.of<LoginBloc>(context).isLogged(),
                          stream:
                              BlocProvider.of<LoginBloc>(context).Sessionstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data)
                              return Container(
                                alignment: Alignment.center,
                                height: 60,
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  allTranslations.text('logout'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            else
                              return Container();
                          }),
                    ),
                  ],
                ), //coulmn
              ),
              drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DrawerHeader(
                      child: StreamBuilder<bool>(
                          initialData:
                              BlocProvider.of<LoginBloc>(context).isLogged(),
                          stream:
                              BlocProvider.of<LoginBloc>(context).Sessionstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data) {
                              //getUserName();
                              return Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Icon(Icons.notifications_paused),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        LoginBloc.nameLogin != null
                                            ? LoginBloc.nameLogin
                                            : userName,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: AppColors.validValueColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                alignment: Alignment.topLeft,
                                child: Icon(Icons.notifications_paused),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/logo.png'),
                                        fit: BoxFit.cover)),
                              );
                            }
                          }),
                      //container
                      decoration: BoxDecoration(color: AppColors.appBackground),
                    ),

                    StreamBuilder<bool>(
                        initialData:
                            BlocProvider.of<LoginBloc>(context).isLogged(),
                        stream:
                            BlocProvider.of<LoginBloc>(context).Sessionstream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.data) {}
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            child: Visibility(
                              visible: snapshot.hasData ? !snapshot.data : true,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.green)),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ParentAuthPage(
                                                login: 1,
                                              )),
                                      (Route<dynamic> route) => false);
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text(
                                    allTranslations
                                        .text('sign_in_up')
                                        .toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          );
                        }),

                    Expanded(
                      child: ListView(children: drawerOptions),
                    ), //listview

                    GestureDetector(
                      onTap: () {
                        Alert(
                          context: context,
                          title: allTranslations.text('logout'),
                          desc: allTranslations.text('logout_msg'),
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                              child: Text(
                                allTranslations.text('agree'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context).logout();
                                Navigator.pop(context);
                                LoginBloc.nameLogin = "null";
                              },
                              width: 120,
                            ),
                            DialogButton(
                              child: Text(
                                allTranslations.text('cancel'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      },
                      child: StreamBuilder<bool>(
                          initialData:
                              BlocProvider.of<LoginBloc>(context).isLogged(),
                          stream:
                              BlocProvider.of<LoginBloc>(context).Sessionstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data)
                              return Container(
                                alignment: Alignment.center,
                                height: 60,
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  allTranslations.text('logout'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            else
                              return Container();
                          }),
                    ),
                  ],
                ), //coulmn
              ),
              body: WillPopScope(
                onWillPop: () async {
                  if (bloc.currentScreen == NavigationScreen.HOME) {
                    if (_cateogyBloc.isStackIsEmpty()) {
                      // ignore: missing_return
                      SystemNavigator.pop();
                    } else {
                      // ignore: missing_return
                      _cateogyBloc.removeCateogryFromStack();
                    }
                  } else
                    return false;
                },
                child: StreamBuilder<NavigationScreen>(
                  initialData: NavigationScreen.HOME,
                  stream: bloc.stream,
                  builder: (context, snap) {
                    return _getDrawerItemWidget(snap.data);
                  },
                ),
              ));
        },
      ),
    ); //scaffold
  }

  _onSelectItem(int index) {
    //  setState(() => _navSelectedIndex = index);

    if (index == 2) {
      bloc.navigateToScreen(NavigationScreen.MYADS);
    } else if (index == 1) {
      bloc.navigateToScreen(NavigationScreen.PRFOILE);
    } else if (index == 3) {
      bloc.navigateToScreen(NavigationScreen.FAVROITE);
    } else if (index == 0) {
      bloc.navigateToScreen(NavigationScreen.HOME);
    } else if (index == 4) {
      bloc.navigateToScreen(NavigationScreen.SETTINGS);
    } else if (index == 9) {
      bloc.navigateToScreen(NavigationScreen.POLICY);
    } else if (index == 6) {
      bloc.navigateToScreen(NavigationScreen.RuLES);
    } else if (index == 7) {
      bloc.navigateToScreen(NavigationScreen.ABOUT);
    } else if (index == 8) {
      bloc.navigateToScreen(NavigationScreen.FAQ);
    } else if (index == 12) {
      bloc.navigateToScreen(NavigationScreen.SAFETY);
    } else {
      bloc.navigateToScreen(NavigationScreen.CONTACT_US);
    }
    Navigator.pop(context);
  }

  Widget createNavItem(NavItem nav, int index) {
    if (nav.isExpanded) {
      List<Widget> subItemlist = [];
      return ExpansionTile(
        leading: Icon(nav.navIcon),
        trailing: Icon(Icons.keyboard_arrow_down),
        title: Text(
          nav.name,
          textAlign: TextAlign.start,
        ),
        children: <Widget>[
          Column(
            children: [
              ListTile(
                  leading: Icon(Icons.book),
                  title: Text(allTranslations.text('rules')),
                  onTap: () => _onSelectItem(6)),
              ListTile(
                  leading: Icon(Icons.article),
                  title: Text(allTranslations.text('about_us')),
                  onTap: () => _onSelectItem(7)),
              ListTile(
                  leading: Icon(Icons.info),
                  title: Text(allTranslations.text('policy')),
                  onTap: () => _onSelectItem(9)),
              ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text(allTranslations.text('questions')),
                  onTap: () => _onSelectItem(8)),
              ListTile(
                  leading: Icon(Icons.call),
                  title: Text(allTranslations.text('contact_us')),
                  onTap: () => _onSelectItem(10)),
              ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text(allTranslations.text('safety')),
                  onTap: () => _onSelectItem(12))
            ],
          )
        ],
      );
    } else {
      return ListTile(
        leading: Icon(nav.navIcon),
        title: Text(nav.name),
        selected: index == _navSelectedIndex,
        onTap: () => _onSelectItem(index),
      );
    }
  }

  _getDrawerItemWidget(NavigationScreen screen) {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
    }
    switch (screen) {
      case NavigationScreen.HOME:
        return CategoryListFragment();

      case NavigationScreen.FAVROITE:
        if (BlocProvider.of<LoginBloc>(context).isLogged())
          return new FavroitePage();
        break;

      case NavigationScreen.OFFER:
        return BlocProvider(bloc: CategoryBloc(), child: new OfferPage());

      case NavigationScreen.PRFOILE:
        if (BlocProvider.of<LoginBloc>(context).isLogged())
          return new ProfilePage();
        break;

      case NavigationScreen.MYADS:
        if (BlocProvider.of<LoginBloc>(context).isLogged())
          return new MyAdsPage();
        break;
      case NavigationScreen.SETTINGS:
        return new GeneralSettingsPage();
        break;

      default:
        return CategoryListFragment();
    }
    return CategoryListFragment();
  }

  Future getUserName() async {
    if (BlocProvider.of<LoginBloc>(context).isLogged()) {
      UserInfo userInfo = await preferences.getUserInfo();
      userName = userInfo.firstName + " " + userInfo.secondName;
      userCountryId = userInfo.countryId;

      //  _controller.sink.add(userName);
      print(userName + "rrrrrr");
      print("usercountryId:${userCountryId}");
    } else {
      userName = "";
    }
  }

  _openSocail(int x) async {
    String url;
    if (x == 1) {
      url = await APIConstants.getFaceBookUsUrl();
      _getSocialLink(url);
    } else if (x == 2) {
      url = await APIConstants.getTwitterUsUrl();
      _getSocialLink(url);
    } else if (x == 3) {
      url = await APIConstants.getInstaUsUrl();
      _getSocialLink(url);
    }
  }

  _getSocialLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  Future setIsFirst() async {
    await preferences.saveIsFirstTime(false);
  }

  void getCountryId() async {
    cId = await preferences.getCountryID();
    countryId = int.parse(cId);
    print("usercountryId:${countryId}");
  }
}
