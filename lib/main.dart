/*import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Localization Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Localization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization_app/localization/localizations.dart';

import 'package:flutter_localization_app/screen/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/SecondScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    print('setLocale()');
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');

    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
          title: 'Localization Demo',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(primarySwatch: Colors.blue),
          home: new SplashScreen(),
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('hi', ''), // Hindi
          ],
          locale: locale,
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => new HomeScreen(),
            '/Second_Screen': (BuildContext context) => new SecondScreen(),
          });
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('languageCode') == null) {
      return null;
    }

    print('_fetchLocale():' +
        (prefs.getString('languageCode') +
            ':' +
            prefs.getString('countryCode')));

    return Locale(
        prefs.getString('languageCode'), prefs.getString('countryCode'));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          elevation: 0.2 ,
          backgroundColor: const Color(0xFFF6F8FA),
          title: new Center(
            child: new Text(
              AppLocalizations.of(context).appNameShort,
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: new Container(
            child: new Column(
          children: <Widget>[
            _buildMainWidget(),
//            _buildLanguageWidget(),
            Row(
              children: <Widget>[
                FlatButton(onPressed: setHindi, child: Text("Hindi"),),
                FlatButton(onPressed: setEnglish, child: Text("English")),
                FlatButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/Second_Screen'), child: Text("Second Screen")),

              ],
            )
          ],
        )));
  }

  Widget _buildMainWidget() {
    return new Flexible(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildHeaderWidget(),
            _buildTitleWidget(),
            _buildDescWidget(),
          ],
        ),
      ),
      flex: 9,
    );
  }

  Widget _buildHeaderWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(
            new Radius.circular(8.0),
          ),
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: new AssetImage(
              'assets/images/ic_banner.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
      child: Text(
        AppLocalizations.of(context).title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: Text(
          AppLocalizations.of(context).desc,
          style: TextStyle(
              color: Colors.black87,
              inherit: true,
              fontSize: 13.0,
              wordSpacing: 8.0),
        ),
      ),
    );
  }





  Future<String> _getLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    print('_fetchLocale():' + prefs.getString('languageCode'));
    return prefs.getString('languageCode');
  }





  void _updateLocale(String lang, String country) async {
    print(lang + ':' + country);

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', lang);
    prefs.setString('countryCode', country);

    MyApp.setLocale(context, Locale(lang, country));
  }


  void setHindi(){
    _updateLocale('hi', '');
  }

  void setEnglish(){
    _updateLocale('en', '');
  }






}



