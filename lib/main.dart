import 'package:flutter/material.dart';
import 'data/database_helper.dart';
import 'views/admin_backend.dart';
import 'views/shopping_cart.dart';
import 'data/constant_data.dart' as cd;
import 'views/store_front.dart';
import 'views/splash.dart';

/* 
  main
  See 'data/database.dart' for database helper methods
  See 'data/constant_data.dart' for references to predifined variables.
 */

final GlobalKey<NavigatorState> nKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initize database set path and version to sqflite database - database table(s) found in 'data/database.dart'
  DatabaseHelper _db = DatabaseHelper();
  await _db.initDb();

  //run app
  runApp(MaterialApp(
    title: cd.appName,
    home: SplashView(),
    theme: ThemeData(fontFamily: cd.defaultFont),
    routes: routes,
    navigatorKey: nKey,
  ));
}

// app routes
var routes = <String, WidgetBuilder>{
  cd.splashView: (BuildContext context) => SplashView(),
  cd.adminView: (BuildContext ccontext) => AdminView(),
  cd.cartView: (BuildContext ccontext) => ShoppingCartView(),
  cd.storefrontView: (BuildContext ccontext) => StoreFrontView(),
};
