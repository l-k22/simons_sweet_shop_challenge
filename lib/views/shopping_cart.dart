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

  Widget clearCartDataBtn() {
    return ListTile(
      tileColor: cd.primaryColor,
      selectedTileColor: cd.primaryColor,
      title: Text(
        'Clear all Cart Data',
        style: cd.h2Style,
      ),
      leading: Icon(Icons.download_rounded),
      shape: cd.roundedRectangleBody,
      onTap: () {
        sssBloc.shopSink.add(ShopAction.ClearCartData);
        Future.delayed(Duration(milliseconds: 500),
            () => Navigator.pop(context)); // close nav
      },
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
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data?[index] as OrderModel;
                      return orderCardWidget(order: order);
                    }));
          } else {
            return Text('The cart is empty',
                style: cd.h3Style); //TODO: blank card place holder
          }
        });
  }

  Widget orderCardWidget({OrderModel? order}) {
    return order != null
        ? Card(
            shape: cd.roundedRectangleBody,
            elevation: 6,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FittedBox(
                  fit: BoxFit.fill,
                  child: Stack(children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(cd.borderRadius),
                            image: DecorationImage(
                                image: ExactAssetImage('assets/Sweets.png'),
                                fit: BoxFit.cover)),
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
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
                        onPressed: () async {
                          if (order.id != null) {
                            await sssBloc.removeOrder(order.id!);
                            sssBloc.shopSink.add(ShopAction.FetchAllOrders);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, shape: CircleBorder()),
                      ),
                    ),
                  ])),
              Flexible(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.all(cd.paraPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: textFormatter(order),
                      )))
            ]))
        : Text('The cart is empty',
            style: cd.h3Style); // add mock data via admin drawer
  }

  List<Widget> textFormatter(OrderModel order) {
    List<Widget> wArray = [];
    List<Widget> packs = [];
    var total = 0;
    if (order.packs!.length > 0) {
      order.packs?.forEach((key, value) {
        packs.add(Text('$value x $key', style: cd.paraStyle));
      });
    }

    wArray.add(Text(
      '${cd.mockSweetName} x ${order.amount}',
      style: cd.h2Style,
    ));

    wArray.addAll(packs);
    wArray.add(Text('Total = ${order.totalPacks}', style: cd.h3Style));

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
