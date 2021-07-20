/* 
  Our simple splash screen

 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;
import 'package:simons_sweet_shop_challenge/utils/loading_indicator.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // this would be a good time to fetch data from the database for the store front
    Future.delayed(
        Duration(seconds: 3),
        () =>
            viewPicker()); // display screen for X seconds before moving on to next screen
  }

  void viewPicker() async {
    // add some logic here
    // if sweet pack table empty send to admin screen else storefront

    Navigator.pushReplacementNamed(context, cd.storefrontView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(cd.bodyPadding),
        decoration: new BoxDecoration(
          image: backgroundImage,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingIndicator(''),
              Text(
                cd.appName,
                style: cd.shopNameStyleBig,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage backgroundImage = DecorationImage(
      colorFilter:
          ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
      image: ExactAssetImage('assets/Logo@2x.png'),
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeat,
      alignment: Alignment.center);
}
