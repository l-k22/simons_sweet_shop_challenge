import 'package:flutter/material.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;

/* 
  CustomAppBar widget
  returns out custom app bar
  iconToggle() displays a different icon depending on the route
 */
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(cd.appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var currentRoute;
  var _ctx;
  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.transparent,
      body: Container(
          padding: EdgeInsets.only(left: cd.bodyPadding, right: cd.bodyPadding),
          margin: EdgeInsets.only(bottom: cd.paraMargin),
          child: AppBar(
            toolbarHeight: cd.appBarHeight,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(('assets/Logo@2x.png'), height: 59),
                Text(
                  cd.shopName,
                  style: cd.shopNameStyle,
                )
              ],
            ),
            actions: [iconToggle(context)],
          )),
    );
  }

  Widget iconToggle(BuildContext context) {
    // check the current route name
    currentRoute = (ModalRoute.of(context)!.settings.name);
    if (currentRoute == cd.storefrontView) {
      return IconButton(
        color: cd.brandingColor,
        onPressed: () => Navigator.pushNamed(context, cd.adminView),
        icon: Icon(Icons.person),
      );
    }

    if (currentRoute == cd.adminView) {
      return IconButton(
        color: cd.brandingColor,
        onPressed: () => Navigator.pushNamed(context, cd.storefrontView),
        icon: Icon(Icons.shopping_cart),
      );
    } else {
      return Container(); // according to mockup no icon displayed on cart page
    }
  }
}
