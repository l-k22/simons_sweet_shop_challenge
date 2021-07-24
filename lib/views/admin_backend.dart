import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simons_sweet_shop_challenge/bloc/sss_bloc.dart';
import 'package:simons_sweet_shop_challenge/data/constant_data.dart' as cd;
import 'package:simons_sweet_shop_challenge/data/pack_model.dart';
import 'package:simons_sweet_shop_challenge/presentation/app_bar.dart';

/* 
  Admin view
  Gives user the ability to add, edit or delete pack sizes

  Navigation drawer has the Load Mock Data button to setup the store.
  
 */
class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();
  final sssBloc = SSSBloc();

  var _backendView;

  _AdminViewState() {
    // fetch data
    sssBloc.shopSink.add(ShopAction.FetchAllPacks);
    _backendView = fetchBackendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white38),
          child: Drawer(
            // drawer to mock data button
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: cd.drawerPaddingVertical,
                  horizontal: cd.drawerPadding),
              children: [fetchMockDataBtn()],
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
      onTap: () {
        sssBloc.shopSink.add(ShopAction.AddMockData);
        sssBloc.shopSink.add(ShopAction.FetchAllPacks);
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
        child: StreamBuilder<List<PackModel>>(
            stream: sssBloc.packStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var pack = snapshot.data?[index] as PackModel;
                      return packRowWidget(pack: pack);
                    });
              } else
                return packRowWidget();
            }));
  }

  Widget packRowWidget({PackModel? pack}) {
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 1,
            child: TextFormField(
              initialValue: (pack?.size != null) ? '${pack?.size}' : '${0}',
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
                if (value == null || value.isEmpty || int.parse(value) < 1) {
                  return 'enter an amount';
                }
                return null;
              },
            )),
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
              onPressed: () {
                sssBloc.shopSink.add(ShopAction.EditPackSize);

                // _toggleEditSaveBtn();
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                // if (_formKey.currentState!.validate()) {
                //   // Process data.
                // }
              },
            ),
            Flexible(
                child: IconButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    onPressed: () {
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
    _textController.dispose();
    super.dispose();
  }
}
