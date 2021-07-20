/* 
  SSSBloc 
  class contains our business logic for ordering packs
 */

import 'dart:async';
import 'dart:collection';
import 'package:simons_sweet_shop_challenge/data/database_helper.dart';
import 'package:simons_sweet_shop_challenge/data/order_model.dart';
import 'package:simons_sweet_shop_challenge/data/pack_calculator.dart';

import '../data/pack_model.dart';

enum ShopAction {
  AddToCart,
  RemoveOrder,
  FetchAllOrders,
  AddPackSize,
  EditPackSize,
  RemovePackSize,
  SavePackSize,
  FetchAllPacks,
  AddMockData
}
enum PackAction {
  AddPackSize,
  EditPackSize,
  RemovePackSize,
  SavePackSize,
  FetchAllPacks,
  AddMockData
}

class SSSBloc {
  final _stateShopStreamController = StreamController<ShopAction>.broadcast();
  final _statePackStreamController =
      StreamController<List<PackModel>>.broadcast();
  final _stateBoolStreamController = StreamController<bool>.broadcast();
  final _stateOrderStreamController =
      StreamController<List<OrderModel>>.broadcast();
  final SplayTreeMap<PackModel, int> packMap = SplayTreeMap();

  bool editSaveToggleBtn = false;

  StreamSink<ShopAction> get shopSink => _stateShopStreamController.sink;
  Stream<ShopAction> get _shopStream => _stateShopStreamController.stream;

  StreamSink<List<PackModel>> get packSink => _statePackStreamController.sink;
  Stream<List<PackModel>> get packStream => _statePackStreamController.stream;

  StreamSink<bool> get _boolSink => _stateBoolStreamController.sink;
  Stream<bool> get boolStream => _stateBoolStreamController.stream;

  StreamSink<List<OrderModel>> get orderSink =>
      _stateOrderStreamController.sink;
  Stream<List<OrderModel>> get orderStream =>
      _stateOrderStreamController.stream;

  SSSBloc() {
    editSaveToggleBtn = false;

    _shopStream.listen((event) async {
      switch (event) {
        case ShopAction.FetchAllPacks:
          try {
            var packs = await fetchAllPacks();
            packSink.add(packs);
          } catch (e) {
            packSink.addError('Something went wrong unable to fetch packs');
          }

          break;
        case ShopAction.AddPackSize:
          await addPack(0);
          break;

        case ShopAction.EditPackSize:
          editSaveToggleBtn = !editSaveToggleBtn;
          _boolSink.add(editSaveToggleBtn);

          break;
        case ShopAction.SavePackSize:
          editSaveToggleBtn = false;
          _boolSink.add(editSaveToggleBtn);
          break;
        case ShopAction.RemovePackSize:
          break;
        // Customer calls
        case ShopAction.AddToCart:
          var order = await fetchAllOrders();
          orderSink.add(order);
          break;
        case ShopAction.RemoveOrder:
          // removeOrder();
          break;
        case ShopAction.FetchAllOrders:
          await fetchAllOrders();
          break;
        case ShopAction.AddMockData:
          await fetchMockData();
          break;
      }
    });
  }
  void dispose() {
    _stateShopStreamController.close();
    _stateBoolStreamController.close();
    _stateOrderStreamController.close();
    _statePackStreamController.close();
  }

  //TODO: List of packs

//TODO: Stream Controllers

//TODO: String SINK Getter

//TODO: Constructor - add data, remove data, edit data, listen to changes

//TODO: Core functions
  Future<List<PackModel>> fetchAllPacks() async {
    /* 
    // We make an api call here but for this demo I will be using mock data stored in the database.
    // install import the intl and http packages
    String exampleApiUrl = 'https://....'
    List<PackModel>> fetchAllPacksFromApi = await http.get(exampleApiUrl, headers: {
      "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Example-Token": "${encryptedToken}"});
      final statusCode = fetchAllPacksFromApi.statusCode;
      Map<String, dynamic> resBody = json.decode(fetchAllPacksFromApi.body);
      if (statusCode < 200 || statusCode >= 300 || resCRM.body == null) {
        //connection failed display toast message
        //print('API Connection failed: $statusCode $exampleApiUrl');
      } else { 
        // check body length > 2 //{}
        // map body to data to model
        // foreach loop through List<PackModel> save each element to database.
        // fetch data from database using the fetchAllPacks method.
      }
     */
    var db = DatabaseHelper();
    var packs = await db.fetchAllPacks();
    print('fetchPacks Bloc $packs');
    return packs;
  }

  Future<void> removePack(int size) async {
    /* 
      This method is for the admin to create/delete/edit packs. 
      We would use a POST rest call to the API with an id to remove the pack
      We would then make another GET call to the API to retrieve the full list
      using our fetchAllPacks().
      Note* We would have an internet connection check method to ensure we get 
      the latest data from the server otherwise the phone's list would not be 
      out of sync with the server. We would then store the updated list on the 
      device's database for retrieval.
     */
    var db = DatabaseHelper();
    await db.removePack(size); // remove pack from mock data
    // return await db
    //     .fetchAllPacks(); // return the newly updated data from database
  }

  Future<PackModel> getPack(int size) async {
    var db = DatabaseHelper();
    return await db
        .getPack(size); // return the newly updated data from database
  }

  Future<void> addPack(int size) async {
    var db = DatabaseHelper();
    PackModel pack = PackModel(size: size);
    await db.addPack(pack);
    // return await db
    //     .fetchAllPacks(); // return the newly updated data from database
  }

  Future<List<PackModel>> editPack(int previousSize, int newSize) async {
    var db = DatabaseHelper();
    await removePack(previousSize);

    PackModel pack = PackModel(size: newSize);
    // we can use the same method since our conflictAlgorithm is set to replace
    await db.addPack(pack);

    return await db
        .fetchAllPacks(); // return the newly updated data from database
  }

  Future<List<OrderModel>> fetchAllOrders() async {
    var db = DatabaseHelper();
    var orders = await db.fetchAllOrders();
    print('bloc orders: $orders');
    return orders;
  }

  Future<void> removeOrder(int orderId) async {
    var db = DatabaseHelper();
    await db.removeOrder(orderId); // remove pack from mock data
    // return await db
    //     .fetchAllOrders(); // return the newly updated data from database
  }

  Future<void> addToCart(int amount) async {
    var db = DatabaseHelper();
    SplayTreeMap<int, int> packTree = SplayTreeMap();
    OrderModel order = OrderModel(amount: amount, packs: null);
    print('addToCart received call');
    List<PackModel> dbPacks = await db.fetchAllPacks();
    List<int> packArray = [];
    dbPacks.forEach((element) {
      packArray.add(element.size);
      packTree[element.size] = 0;
    });
    PackCalculator(orderAmount: amount, packs: packArray, packMap: packTree);
    _stateOrderStreamController.sink.add([order]);
    // return await db
    //     .fetchAllOrders(); // return the newly updated data from database
  }

  Future<void> fetchMockData() async {
    var db = DatabaseHelper();
    await db.addMockData();
  }
}
