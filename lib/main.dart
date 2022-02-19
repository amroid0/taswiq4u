import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:olx/data/bloc/login_bloc.dart';
import 'package:olx/data/bloc/profile_bloc.dart';
import 'package:olx/generated/i18n.dart';
import 'package:olx/pages/login_page.dart';
import 'package:olx/pages/parentAuthPage.dart';
import 'package:olx/pages/splash_page.dart';
import 'package:olx/utils/global_locale.dart';

import 'data/bloc/bloc_provider.dart';
import 'data/bloc/languge_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await allTranslations.init();

  runApp(Application());}


class Application extends StatefulWidget {
  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  TranslationsBloc? translationsBloc;

  @override
  void initState() {
    super.initState();
    translationsBloc = TranslationsBloc();
  }

  @override
  void dispose() {
    translationsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc!,
      child: BlocProvider<LoginBloc>(
        bloc: new LoginBloc(),
        child: BlocProvider<ProfileBloc>(
          bloc: new ProfileBloc(),
          child: StreamBuilder<Locale?>(
              stream: translationsBloc!.currentLocale,
              initialData: allTranslations.locale,
              builder: (BuildContext context, AsyncSnapshot<Locale?> snapshot) {

                return MaterialApp(
                  title: 'Taswiq4U',
                   debugShowCheckedModeBanner: false,
                  theme: ThemeData(

                      primarySwatch: Colors.green,
                      accentColor: Color(0xff53B553),
                    fontFamily: 'cairo',
                    textTheme: TextTheme(
                      headline5: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                      bodyText2: TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.normal,
                      ),
                      headline6: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                      ),
                      subtitle2: TextStyle(
                        fontSize: 11.0,
                        fontStyle: FontStyle.normal,
                      ),
                      headline4: TextStyle(fontSize: 13.0, fontStyle: FontStyle.normal, color: Color.fromRGBO(81, 81, 81, 1)),
                      button: TextStyle(fontSize: 16.0, fontStyle: FontStyle.normal, color: Colors.white),
                    ),
                  ),
                  ///
                  /// Multi lingual
                  ///
                  locale: snapshot.data ?? allTranslations.locale,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: allTranslations.supportedLocales(),

                  home: SplashScreen(),
                );
              }
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: allTranslations.text("page.title")!,
      theme: ThemeData(

        primarySwatch: Colors.green,
        accentColor: Color(0xff53B553)
      ),

      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: ProgressHud(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}





































