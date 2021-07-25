import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simons_sweet_shop_challenge/bloc/sss_bloc.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;
import 'package:simons_sweet_shop_challenge/data/pack_model.dart';
import 'package:simons_sweet_shop_challenge/presentation/app_bar.dart';

/* 
  Admin view
  Gives user the ability to add, edit or delete pack sizes

  Navigation drawer has the Load Mock Data and Clear Cart buttons to auto setup the store.
  
 */
class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // list to keep track of these dynamically created controllers
  List<TextEditingController> textControllersList = [];
  final sssBloc = SSSBloc();
  bool _toggle = false;
  var _backendView;

  @override
  void initState() {
    super.initState();
    _toggle = false;
    sssBloc.shopSink.add(ShopAction.FetchAllPacks);
    _backendView = fetchBackendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      // use end drawer since swipe left to right on ios returns user to previous screen.
      endDrawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white38),
          child: Drawer(
            // drawer to mock data button
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: cd.drawerPaddingVertical,
                  horizontal: cd.drawerPadding),
              children: ListTile.divideTiles(
                  color: cd.brandingColor,
                  context: context,
                  tiles: [fetchMockDataBtn(), clearCartDataBtn()]).toList(),
            ),
          )),
      body: _backendView,
    );
  }

  Widget fetchMockDataBtn() {
    return ListTile(
      tileColor: cd.primaryColor,
      selectedTileColor: cd.primaryColor,
      title: Text(
        'Load Mock Data',
        style: cd.h2Style,
      ),
      leading: Icon(Icons.download_rounded),
      shape: cd.roundedRectangleBody,
      onTap: () async {
        sssBloc.shopSink.add(ShopAction.AddMockData);
        Future.delayed(Duration(milliseconds: 500), () {
          // appears to be a race condition causing the the view to not render complete list
          sssBloc.shopSink.add(ShopAction.FetchAllPacks);
          Navigator.pop(context); // close nav
        });
      },
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

  Widget fetchBackendData() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: cd.bodyPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Card(
                  shape: cd.roundedRectangleBody,
                  elevation: 8,
                  child: Column(
                    children: [_header(), descriptionWidget(), packWidget()],
                  ))),
          addPackSizeBtn()
        ]));
  }

  Widget _header() {
    return Container(
        width: double.infinity,
        color: cd.headerBG,
        padding: EdgeInsets.all(cd.btnPadding),
        child: Text(
          cd.adminHeader,
          style: cd.h1Style,
          textAlign: TextAlign.center,
        ),
        margin: EdgeInsets.only(bottom: cd.headerMargin));
  }

  Widget descriptionWidget() {
    return Container(
        margin: EdgeInsets.only(bottom: cd.paraMargin),
        padding: EdgeInsets.only(
            left: cd.paraPadding,
            right: cd.paraPadding,
            bottom: cd.paraPadding),
        child: Text(
          cd.adminDescription,
          style: cd.paraStyle,
        ));
  }

// In hindsight this should be it's own widget
  Widget packWidget() {
    return Flexible(
        child: Form(
            key: _formKey,
            child: StreamBuilder<List<PackModel>>(
                stream: sssBloc.packStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error ?? "Error"}',
                        style: cd.h2Style);
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var pack = snapshot.data![index];
                          return packRowWidget(pack: pack);
                        });
                  } else
                    return Text(
                      'No packs',
                      style: cd.h2Style,
                    );
                })));
  }

  Widget packRowWidget({required PackModel pack}) {
    var textController = TextEditingController(text: '${pack.size}');
    textControllersList.add(textController); // add to our list of controllers
    return ListTile(
        key: Key('${pack.size}'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: StreamBuilder<bool>(
                    stream: sssBloc.boolStream,
                    builder: (context, snapshot) {
                      if (!_toggle) {
                        return TextFormField(
                          key: Key('${pack.size}'),
                          initialValue: '${pack.size}',
                          enabled: false,
                          style: cd.h3StyleDisabled,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            fillColor: Colors.red,
                            contentPadding: EdgeInsets.all(0),
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                          ),
                        );
                      } else
                        return TextFormField(
                          key: Key('${pack.size}'),
                          enabled: _toggle,
                          controller: textController,
                          style: cd.h3Style,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp("[-.,]")) // disable decimal and minus
                          ],
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) < 1) {
                              return 'enter an amount';
                            }
                            return null;
                          },
                        );
                    })),
            Flexible(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: cd.primaryColor, elevation: 1),
                  child: StreamBuilder(
                    stream: sssBloc.boolStream,
                    builder: (context, snapshot) {
                      return snapshot.data == false || !snapshot.hasData
                          ? Text(cd.editbtn, style: cd.h3Style)
                          : Text(cd.saveBtn, style: cd.h3Style);
                    },
                  ),
                  onPressed: () async {
                    setState(() {
                      _toggle = !_toggle;
                    });
                    sssBloc.shopSink.add(ShopAction.EditPackSize);
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      await sssBloc.editPack(
                          pack.size, int.parse(textController.value.text));
                    }
                  },
                ),
                Flexible(
                    child: IconButton(
                        icon: const Icon(Icons.delete_forever_outlined),
                        onPressed: () async {
                          await sssBloc.removePack(pack.size);
                          sssBloc.shopSink.add(ShopAction.RemovePackSize);
                        }))
              ],
            )),
          ],
        ));
  }

  Widget addPackSizeBtn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: cd.btnPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: cd.secondaryColor),
        onPressed: () {
          // add new row.
          sssBloc.shopSink.add(ShopAction.AddPackSize);
          sssBloc.shopSink.add(ShopAction.FetchAllPacks);
        },
        child: const Text(cd.addPackSize, style: cd.h3Style),
      ),
    );
  }

  @override
  void dispose() {
    // dispose controllers!
    textControllersList.forEach((textController) {
      textController.dispose();
    });
    super.dispose();
  }
}
