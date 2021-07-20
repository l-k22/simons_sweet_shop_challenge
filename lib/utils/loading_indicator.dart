import 'package:flutter/material.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;

/* 
  LoadingIndicator
  Custom circular progress indicator
  Save time duplicating it simply call this class where ever you need it
 */
class LoadingIndicator extends StatelessWidget {
  LoadingIndicator(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 0),
      children: [
        SizedBox(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(cd.primaryColor)),
            height: 10.0,
            width: 100.0),
        SizedBox(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              message,
              style: cd.shopNameStyle,
            ),
          ),
        ),
      ],
    );
  }
}
