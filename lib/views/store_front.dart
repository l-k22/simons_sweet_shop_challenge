import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simons_sweet_shop_challenge/bloc/sss_bloc.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:simons_sweet_shop_challenge/presentation/app_bar.dart';

/* 
  StoreFront view
  This view displays the sweet available to order
  User enters the amount they want then hits the Add to Cart button to view ShoppingCart
  
  If you try to order immediately you will not see your orders.
  You must create packs using the Load Mock Data button found in AdminView's hidden
  drawer.
 */
class StoreFrontView extends StatefulWidget {
  @override
  _StoreFrontViewState createState() => _StoreFrontViewState();
}

class _StoreFrontViewState extends State<StoreFrontView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CarouselController _carouselController = CarouselController();
  final _selectAmountInputController = TextEditingController();
  final sssBloc = SSSBloc();
  var _storeFrontView;
  int _current = 0;

  _StoreFrontViewState() {
    _storeFrontView = fetchStoreFront();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _storeFrontView,
    );
  }

  fetchStoreFront() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(left: cd.bodyPadding, right: cd.bodyPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          productTitle(),
          Expanded(
              child: Card(
            shape: cd.roundedRectangleBody,
            elevation: 6,
            child: ListView(
              children: [
                carouselWidget(),
                descriptionWidget(),
                orderWidget(),
              ],
            ),
          )),
          addToCartBtn(),
        ],
      ),
    );
  }

  Widget productTitle() {
    return Container(
        child: Text(
          cd.mockSweetName,
          style: cd.h1Style,
          textAlign: TextAlign.start,
        ),
        margin: EdgeInsets.only(bottom: cd.headerMargin));
  }

  Widget carouselWidget() {
    return Column(children: [
      CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
              height: 254,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: [1, 2, 3, 4, 5].map((i) {
            // mock list
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: cd.borderRadius, topRight: cd.borderRadius),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: ExactAssetImage('assets/Sweets.png'),
                      )),
                ));
              },
            );
          }).toList()),

      // Pagination
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [1, 2, 3, 4, 5].asMap().entries.map((entry) {
          // mock list
          return GestureDetector(
            onTap: () => _carouselController.animateToPage(entry.key),
            child: Container(
              width: 6.0,
              height: 6.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cd.brandingColor
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      )
    ]);
  }

  Widget descriptionWidget() {
    return Container(
        margin: EdgeInsets.only(bottom: cd.paraMargin),
        padding: EdgeInsets.all(cd.paraPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Text('Description', style: cd.h2Style),
                margin: EdgeInsets.only(bottom: cd.paraMargin)),
            Text(
              cd.mockSweetDescription,
              style: cd.paraStyle,
            ),
          ],
        ));
  }

  Widget orderWidget() {
    return Padding(
        padding: EdgeInsets.only(
            left: cd.paraPadding, right: cd.paraPadding, bottom: cd.paraMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: Text(
              'Select Amount ',
              style: cd.h3Style,
            )),
            Flexible(
                child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _selectAmountInputController,
                autofocus: false,
                style: cd.h3Style,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[-.,]"))
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty || int.parse(value) < 1) {
                    return 'enter an amount';
                  }
                  return null;
                },
              ),
            )),
          ],
        ));
  }

  Widget addToCartBtn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: cd.btnPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: cd.secondaryColor),
        child: const Text(cd.addToCartText, style: cd.h3Style),
        onPressed: () async {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.

          if (_formKey.currentState!.validate()) {
            // Process data.
            int orderAmount =
                int.parse(_selectAmountInputController.value.text);

            await sssBloc.addToCart(orderAmount);
            Navigator.pushNamed(context, cd.cartView);
          }
          //TEMP
        },
      ),
    );
  }

  @override
  void dispose() {
    _selectAmountInputController.dispose();
    super.dispose();
  }
}
