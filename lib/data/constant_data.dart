/* 
  Handy helper - One source of truth to reduce repetative code that is prone to typos
 */
import 'package:flutter/material.dart';

/* 
    DATABASE TABLE NAMES
   */
const String databaseName = 'sss_database.db';
const String packSizeTable = 'sss_packs';
const String cartTable = 'sss_cart';
const String sweetNamesTable = 'sss_sweets';
const String sweetTypesTable = 'sss_sTypes';

/* 
    UI STYLE
   */
const String defaultFont = 'Nunito';
const String defaultFontBold = 'NunitoBold';
const double appBarHeight = 100.0;
const double bodyPadding = 42.0;
const double btnPadding = 15.0;
const double headerFontSize = 19.0;
const double h1FontSize = 20.0;
const double h2FontSize = 16.0;
const double h3FontSize = 14.0;
const double paraFontSize = 14.0;
const double bigFontSize = 22.0;
const double headerMargin = 25.0;
const double paraMargin = 20.0;
const double paraPadding = 15.0;
const double drawerPaddingVertical = 30.0;
const double drawerPadding = 15.0;
const Radius borderRadius = Radius.circular(10);
ShapeBorder roundedRectangleBody =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
const Radius borderRadiusSmall = Radius.circular(5);
const Color brandingColor = Color(0xff470F35); // purple
const Color headerBG = Color(0xffBFF3EE); // light green
const Color primaryColor = Color(0xffBFF3EE); // light green
const Color secondaryColor = Color(0xffF4CADA); // pink
const Color dTextColor = Color(0xff000000); // black
const List<BoxShadow> bodyBoxShadow = [
  BoxShadow(blurRadius: 5, offset: Offset(4, 4))
];
const TextStyle shopNameStyle = TextStyle(
    fontSize: headerFontSize,
    color: brandingColor,
    fontWeight: FontWeight.w700);
const TextStyle shopNameStyleBig = TextStyle(
    fontSize: bigFontSize, color: brandingColor, fontWeight: FontWeight.w700);
const TextStyle h1Style = TextStyle(
    fontSize: h1FontSize, color: dTextColor, fontWeight: FontWeight.w700);
const TextStyle h2Style = TextStyle(
    fontSize: h2FontSize, color: dTextColor, fontWeight: FontWeight.w700);
const TextStyle h3Style = TextStyle(
    fontSize: h3FontSize, color: dTextColor, fontWeight: FontWeight.w600);
const TextStyle h3StyleDisabled = TextStyle(
    fontSize: h3FontSize, color: Colors.grey, fontWeight: FontWeight.w600);
const TextStyle paraStyle = TextStyle(
    fontSize: paraFontSize, color: dTextColor, fontWeight: FontWeight.w400);

/* 
    ROUTING
   */

const String splashView = "/splash";
const String adminView = "/backend";
const String storefrontView = "/storefront";
const String cartView = "/shoppingcart";
const String debug = "/debug";

/* 
    Titles
   */
const appName = "Simon's Sweet Shop Challenge";
const shopName = "Simon's";
const author = "Larsson Kabukoba";
const authorUrl = "https://stackoverflow.com/users/469335/f-1";
const host = "Wise.";
const addToCartText = "Add to Cart";
const cartHeader = "Cart";
const adminHeader = "Pack Sizes";
const adminDescription = "Add, edit or remove pack sizes below.";
const addPackSize = "Add Pack Size";
const editbtn = "Edit";
const saveBtn = "Save";
const backBtn = "Back";

/* 
    Mock Data
   */
const mockSweetName = 'Rhubarb & Custard';
const mockSweetDescription =
    "These pink and yellow sweets have a real hit of rhubarb and custard flavour - a classic combination \n\nHard boiled so great for sucking on and they last a long time!";
