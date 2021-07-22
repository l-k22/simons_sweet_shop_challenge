import 'package:flutter/material.dart';
import 'package:simons_sweet_shop_challenge/bloc/sss_bloc.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;
import 'package:simons_sweet_shop_challenge/data/order_model.dart';
import 'package:simons_sweet_shop_challenge/presentation/app_bar.dart';

/* 
  ShoppingCartView
  This view displays the user's sweets order
  User can also remove their order
 */
class ShoppingCartView extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCartView> {
  final sssBloc = SSSBloc();
  var _cartData;
  _ShoppingCartState() {
    // fetch data
    sssBloc.shopSink.add(ShopAction.FetchAllOrders);
    _cartData = fetchCartContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _cartData,
    );
  }

  Widget fetchCartContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: cd.bodyPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle(),
          Flexible(child: Column(children: [cartContentWidget()])),
          backBtnWidget()
        ],
      ),
    );
  }

  Widget cartContentWidget() {
    return StreamBuilder<List<OrderModel>>(
        stream: sssBloc.orderStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data?[index] as OrderModel;
                      return orderCardWidget(order: order);
                    }));
          } else {
            return orderCardWidget(); //TODO: blank card place holder
          }
        });
  }

  Widget orderCardWidget({OrderModel? order}) {
    return order != null
        ? Card(
            shape: cd.roundedRectangleBody,
            elevation: 6,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(cd.borderRadius),
                        image: DecorationImage(
                            image: ExactAssetImage('assets/Sweets.png'),
                            fit: BoxFit.contain)),
                    alignment: Alignment.center,
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(
                        top: cd.paraPadding,
                        left: cd.paraPadding,
                        bottom: cd.paraPadding)),
                Positioned(
                  top: cd.btnPadding,
                  left: cd.btnPadding,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (order.id != null) {
                        sssBloc.removeOrder(order.id!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white, shape: CircleBorder()),
                  ),
                ),
              ]),
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(cd.paraPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: textFormatter(order),
                      )))
            ]))
        : Text('Please configure packs',
            style: cd.h3Style); // add mock data via admin drawer
  }

  List<Widget> textFormatter(OrderModel order) {
    List<Widget> wArray = [];
    List<Widget> packs = [];
    var total;
    // order.packs!.forEach((key, value) {
    //   packs.add(Text('$key x $value', style: cd.paraStyle));
    //   total = total + value;
    // });
    wArray.add(Text('Total = $total', style: cd.h3Style));
    wArray.addAll(packs);
    wArray.add(Text(
      '${cd.mockSweetName} x ${order.amount}',
      style: cd.h2Style,
    ));

    return wArray;
  }

  Widget pageTitle() {
    return Container(
        child: Text(
          cd.cartHeader,
          style: cd.h1Style,
          textAlign: TextAlign.start,
        ),
        margin: EdgeInsets.only(bottom: cd.headerMargin));
  }

  Widget backBtnWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: cd.btnPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: cd.primaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(cd.backBtn, style: cd.h3Style),
      ),
    );
  }
}
