import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olx/data/bloc/NavigationBloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/languge_bloc.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/country_entity.dart';
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
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/country_list_dialog.dart';
import 'package:olx/widget/country_list_sheet.dart';
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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  NaviagtionBloc bloc;
  String userName = "";
  bool isFirst;
  AnimationController _animationController;
  int userCountryId;
  int countryId ;

  StreamController _controller = StreamController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  CategoryBloc _cateogyBloc;

  final _zoomDrawerController = ZoomDrawerController();

  var tabIndex = 0;
 List<String> _history = <String>['سيارة', 'شقة', 'موبايل', 'ايجار'];

  var _langSelectedValue = 0;

  int _countrySelectedValue;

  String cId;

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
    _animationController.dispose();

    super.dispose();
  }

  void _selectedTab(int index) {
    if (index == 1) {
      bloc.navigateToScreen(NavigationScreen.OFFER);
    } else if (index == 2) {
      bloc.navigateToScreen(NavigationScreen.FAVROITE);
    } else if (index == 3) {
      bloc.navigateToScreen(NavigationScreen.PRFOILE);
    } else if (index == 0) {
      bloc.navigateToScreen(NavigationScreen.HOME);
    }
    setState(() {
      tabIndex = index;
    });
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
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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
      } else if (data == NavigationScreen.LANGUAGE) {
        showLanguageSheet();
      } else if (data == NavigationScreen.COUNTRY) {
        showCountrySheet();
      }
    });
    setIsFirst();

    super.initState();
  }

  _toggleAnimation() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    getCountryId();
    List<Widget> drawerOptions = [];

    List<NavItem> NavItemList = [
      NavItem(name: allTranslations.text('home'), navIcon: Icons.home),
     // NavItem(name: allTranslations.text('account'), navIcon: Icons.person),
     // NavItem(
       //   name: allTranslations.text('my_ads'), navIcon: Icons.announcement),
      //NavItem(name: allTranslations.text('favroite'), navIcon: Icons.favorite),
      NavItem(name: allTranslations.text('lang'), navIcon: Icons.g_translate),
      NavItem(name: allTranslations.text('country'), navIcon: Icons.language),
      NavItem(
          name: allTranslations.text('contact_us'),
          navIcon: FontAwesomeIcons.headphones),
      NavItem(
          name: allTranslations.text('links'),
          navIcon: FontAwesomeIcons.link,
          isExpanded: true),
    ];
    for (var i = 0; i < NavItemList.length; i++) {
      var d = NavItemList[i];
      drawerOptions.add(
        createNavItem(d, i),
      );
    }
    drawerOptions.add(StreamBuilder<bool>(
        initialData: BlocProvider.of<LoginBloc>(context).isLogged(),
        stream: BlocProvider.of<LoginBloc>(context).Sessionstream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data)
            return Directionality(
              textDirection: TextDirection.ltr,
              child: ListTile(
                leading: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF1F7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Icon(Icons.logout)),
                title: Text(allTranslations.text('logout')),
                onTap: () {
                  _zoomDrawerController.toggle.call();
                  Alert(
                    context: context,
                    title: allTranslations.text('logout'),
                    desc: allTranslations.text('logout_msg'),
                    style: AlertStyle(
                      isCloseButton: false,
                      alertBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    buttons: [
                      DialogButton(
                        radius: BorderRadius.all(Radius.circular(20)),
                        child: Text(
                          allTranslations.text('ok'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<LoginBloc>(context).logout();
                          LoginBloc.nameLogin = "null";
                        },
                        width: 120,
                        height: 56,
                      ),
                      DialogButton(
                        radius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          width: 120,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: AppColors.accentColor,
                                width: 1,
                              )),
                          child: Center(
                            child: Text(
                              allTranslations.text('cancel'),
                              style: TextStyle(
                                  color: AppColors.accentColor, fontSize: 20),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                        height: 56,
                        color: Colors.white,
                      )
                    ],
                  ).show();
                },
              ),
            );
          else
            return Container();
        }));

    final rightSlide = MediaQuery.of(context).size.width * 0.6;

    return BlocProvider(
        bloc: _cateogyBloc,
        child: StreamBuilder(
            stream: BlocProvider.of<TranslationsBloc>(context).currentLanguage,
            builder: (context, snap) {
              return ZoomDrawer(
                openCurve: Curves.fastOutSlowIn,
                closeCurve: Curves.bounceIn,
                controller: _zoomDrawerController,
                menuScreen: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ListView(children: drawerOptions),
                      ), //listview

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            GestureDetector(
                              onTap: () => _openSocail(1),
                              child: Container(
                                width: 38,
                                height: 38,
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCAD1E0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Icon(FontAwesomeIcons.facebookF,
                                    color: Color(0xff1773EA)),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () => _openSocail(3),
                              child: Container(
                                width: 38,
                                height: 38,
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCAD1E0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Icon(FontAwesomeIcons.instagram,
                                    color: Color(0xff7623BE)),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () => _openSocail(2),
                              child: Container(
                                width: 38,
                                height: 38,
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCAD1E0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.twitter,
                                  color: Color(0xff1D9BF0),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                mainScreen: Scaffold(
                    backgroundColor: Colors.white,
                    key: _scaffoldKey,
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: AppColors.accentColor,
                      onPressed: () => {
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
                              title: (allTranslations.text('ads_add')),
                              desc: (allTranslations.text('err_add_ads')),
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
                      tooltip: 'add',
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      elevation: 2.0,
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          unselectedItemColor: Color(0xff818391),
                          onTap: _selectedTab,
                          currentIndex: tabIndex,
                          unselectedLabelStyle:
                              TextStyle(color: Color(0xff818391)),
                          selectedLabelStyle:
                              TextStyle(color: AppColors.accentColor),
                          items: [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.home_outlined),
                                activeIcon: Icon(
                                  Icons.home,
                                  color: AppColors.accentColor,
                                ),
                                label: (allTranslations.text('home'))),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.local_offer_outlined),
                                activeIcon: Icon(
                                  Icons.local_offer,
                                  color: AppColors.accentColor,
                                ),
                                label: allTranslations.text('offers')),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.favorite_outline),
                                activeIcon: Icon(
                                  Icons.favorite,
                                  color: AppColors.accentColor,
                                ),
                                label: allTranslations.text('favroite')),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.person_outline),
                                activeIcon: Icon(
                                  Icons.person,
                                  color: AppColors.accentColor,
                                ),
                                label: allTranslations.text('account')),
                          ],
                        )),
                    appBar: AppBar(
                        toolbarHeight: 70,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        title: StreamBuilder<NavigationScreen>(
                            initialData: NavigationScreen.HOME,
                            stream: bloc.stream,
                            builder: (context, snapshot) {
                              String title = allTranslations.text('welcome_title');
                               bool isHomeScreen =snapshot.data == NavigationScreen.HOME;
                              switch (snapshot.data) {
                                case NavigationScreen.HOME:
                                  title = allTranslations.text('home');
                                  break;

                                case NavigationScreen.FAVROITE:
                                  if (BlocProvider.of<LoginBloc>(context)
                                      .isLogged()) {
                                    title = allTranslations.text('favroite');
                                  }
                                  break;

                                case NavigationScreen.OFFER:
                                  title = allTranslations.text('offers');

                                  break;
                                case NavigationScreen.PRFOILE:
                                  if (BlocProvider.of<LoginBloc>(context)
                                      .isLogged()) {
                                    title = allTranslations.text('account');
                                  }
                                  break;

                                case NavigationScreen.MYADS:
                                  if (BlocProvider.of<LoginBloc>(context)
                                      .isLogged()) {
                                    title = allTranslations.text('my_ads');
                                  }
                                  break;

                                default:
                                  title = allTranslations.text('welcome_title');
                              }

                              return ListTile(
                                title: Text(
                                  title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Visibility(
                                  visible: isHomeScreen,
                                  child: Text(
                                    allTranslations.text("home_sub_title"),
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xff818391)),
                                  ),
                                ),
                              );
                            }),
                        leadingWidth: 48,
                        centerTitle: false,
                        leading: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFF1F7),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: IconButton(
                                  icon: Image.asset("images/menu_icon.png"),
                                  onPressed: () {
                                    _zoomDrawerController.toggle.call();
                                  }),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          /*IconButton(
                            icon: actionIcon,
                            color: Colors.black,
                            onPressed: () => showSearch(
                              context: context,
                              delegate: DummyDelegate(),
                            ),
                          ),*/
                        ]),
                    //appbar

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
                    )),
                borderRadius: 24.0,
                showShadow: true,
                angle: -12.0,
                slideWidth: MediaQuery.of(context).size.width * 0.65,
              );
            })); //scaffold
  }

  _onSelectItem(int index) {
    //  setState(() => _navSelectedIndex = index);

     if (index == 0) {
      bloc.navigateToScreen(NavigationScreen.HOME);
    } else if (index == 1) {
      bloc.navigateToScreen(NavigationScreen.LANGUAGE);
    } else if (index == 2) {
      bloc.navigateToScreen(NavigationScreen.COUNTRY);
    } else if (index == 3) {
      bloc.navigateToScreen(NavigationScreen.CONTACT_US);
    } else if (index == 7) {
      bloc.navigateToScreen(NavigationScreen.RuLES);
    } else if (index == 8) {
      bloc.navigateToScreen(NavigationScreen.ABOUT);
    } else if (index == 9) {
      bloc.navigateToScreen(NavigationScreen.POLICY);
    } else if (index == 10) {
      bloc.navigateToScreen(NavigationScreen.FAQ);
    } else if (index == 11) {
      bloc.navigateToScreen(NavigationScreen.SAFETY);
    } else {
      bloc.navigateToScreen(NavigationScreen.LOGOUT);
    }
    _zoomDrawerController.toggle.call();
  }

  Widget createNavItem(NavItem nav, int index) {
    if (nav.isExpanded) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: ExpansionTile(
          leading: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Color(0xFFEFF1F7),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: Icon(nav.navIcon)),
          trailing: Icon(Icons.keyboard_arrow_down),
          title: Row(
            children: [
              Text(
                nav.name,
                textAlign: TextAlign.start,
              ),
              SizedBox(width: 100,),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(
                children: [
                  ListTile(
                      title: Text(allTranslations.text('rules')),
                      onTap: () => _onSelectItem(7)),
                  ListTile(
                      title: Text(allTranslations.text('about_us')),
                      onTap: () => _onSelectItem(8)),
                  ListTile(
                      title: Text(allTranslations.text('policy')),
                      onTap: () => _onSelectItem(9)),
                  ListTile(
                      title: Text(allTranslations.text('questions')),
                      onTap: () => _onSelectItem(10)),
                  ListTile(
                      title: Text(allTranslations.text('safety')),
                      onTap: () => _onSelectItem(11))
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: ListTile(
          leading: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Color(0xFFEFF1F7),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: Icon(nav.navIcon)),
          title: Text(nav.name),
          selected: index == _navSelectedIndex,
          onTap: () => _onSelectItem(index),
        ),
      );
    }
  }

  _getDrawerItemWidget(NavigationScreen screen) {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
    }
    switch (screen) {
      case NavigationScreen.HOME:
        return _homeScreen();

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
        return _homeScreen();
    }
    return _homeScreen();
  }

  Widget _homeScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: DummyDelegate(_history),
              );
            },
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffE3E7EF)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: TextField(
                    readOnly: true,
                    enableInteractiveSelection: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: allTranslations.text('search_here'),
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none),
                  ))),
            ),
          ),
        ),
        Expanded(child: CategoryListFragment())
      ],
    );
  }

  void getCountryId() async {
    cId = await preferences.getCountryID();
    countryId = int.parse(cId);
    print("usercountryId:${countryId}");
  }
  Future getUserName() async {
    if (BlocProvider.of<LoginBloc>(context).isLogged()) {
      UserInfo userInfo = await preferences.getUserInfo();
      userName = userInfo.firstName;
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

  void showLanguageSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                allTranslations.text('select_lang'),
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<TranslationsBloc>(context)
                                .setNewLanguage("en");
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: ListTile(
                              title: Text(
                                "English",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        // Divider(height: 2,color: Colors.black,thickness: 1,),

                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<TranslationsBloc>(context)
                                .setNewLanguage("ar");
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: ListTile(
                              title: Text(
                                "اللغه العربيه",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void showCountrySheet() async {
    await CountryListSheet.showModal<CountryEntity>(context,
        label: allTranslations.text('choose_country'),
        selectedValue: CountryEntity(),
        items: List(), onChange: (CountryEntity selected) {
      preferences.saveCountryID(selected.countryId.toString());
      preferences.saveCountry(selected);
      preferences.clearCateogry();
      //BlocProvider.of<CategoryBloc>(context).submitQuery("");
      _countrySelectedValue = selected.countryId;
      Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }
}
