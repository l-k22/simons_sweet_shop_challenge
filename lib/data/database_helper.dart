import 'dart:async';
import 'package:path/path.dart';
import 'package:simons_sweet_shop_challenge/data/pack_model.dart';
import 'package:sqflite/sqflite.dart';

import 'constant_data.dart' as cd;
import 'order_model.dart';
import 'sweet_model.dart';

/* 
  Database Helper class
  Creates, initialises database
  All write methods to database
  Table names listed and retrieved from tableList();
 */

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  var appDb;
  Future<Database> initDb() async {
    var appDb = openDatabase(join(await getDatabasesPath(), cd.databaseName),
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return appDb;
  }

// create database
  _onCreate(Database db, int version) async {
    try {
      await db
          .execute(
        'CREATE TABLE ${cd.packSizeTable}(size INTEGER PRIMARY KEY)',
      )
          .catchError((onError) {
        print(onError); // for testing, replace with toast
      });
      await db
          .execute(
        'CREATE TABLE ${cd.cartTable}(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, amount INTEGER, packs TEXT)',
      )
          .catchError((onError) {
        print(onError); // for testing, replace with toast
      });
      await db
          .execute(
        'CREATE TABLE ${cd.sweetNamesTable}(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, sku TEXT, stock INTEGER, description TEXT)',
      )
          .catchError((onError) {
        print(onError); // for testing, replace with toast
      });
    } catch (e) {
      print(e);
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    for (var table in tableList()) {
      batch.execute('DROP TABLE IF EXISTS $table');
    }
    await batch.commit();
    _onCreate(db, newVersion);
  }

  List tableList() {
    return [
      cd.packSizeTable,
      cd.cartTable,
      cd.sweetNamesTable
    ]; // add new tables to this list !!
  }

/* 
  Database queries
 */

// fetch all orders
  Future<List<OrderModel>> fetchAllOrders() async {
    final Database dbClient = await initDb();
    List<OrderModel> orderList = [];
    final List<Map<String, dynamic>> maps = await dbClient.query(cd.cartTable);
    maps.asMap().forEach((key, value) {
      OrderModel oM = OrderModel.fromMap(value);
      orderList.add(oM);
    });

    return orderList;
  }

// fetch all packs
  Future<List<PackModel>> fetchAllPacks() async {
    List<PackModel> packList = [];
    final Database dbClient = await initDb();
    final List<Map<String, dynamic>> maps =
        await dbClient.query(cd.packSizeTable);

    maps.asMap().forEach((key, value) {
      PackModel pM = PackModel.fromMap(value);
      packList.add(pM);
    });

    return packList;
  }

// add new pack or update an existing one
  Future<void> addPack(PackModel item) async {
    final Database dbClient = await initDb();
    try {
      await dbClient.insert(cd.packSizeTable, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(
          '....ERROR! Not able to save pack data to database \nitem: $item \nerror: $e');
    }
  }

// get a pack
  Future<PackModel> getPack(int id) async {
    try {
      final Database dbClient = await initDb();
      List<Map> maps = await dbClient
          .query(cd.packSizeTable, where: 'id = ?', whereArgs: [id]);
      List<PackModel> packArr = List.generate(maps.length, (i) {
        return PackModel(size: int.parse(maps[i]['size']));
      });
      if (packArr.length > 0) {
        return packArr.first;
      }
    } catch (e) {
      print('....ERROR! Not able to remove pack data to database $e');
    }

    return PackModel(size: 0);
  }

// remove a pack
  Future<void> removePack(int id) async {
    try {
      final Database dbClient = await initDb();
      await dbClient
          .delete(cd.packSizeTable, where: 'size = ?', whereArgs: [id]);
    } catch (e) {
      print('....ERROR! Not able to remove pack data to database $e');
    }
  }

  Future<void> addOrderToCart(OrderModel item) async {
    final Database dbClient = await initDb();
    try {
      await dbClient.insert(cd.cartTable, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('....ERROR! Not able to save pack data to database $e');
    }
  }

// remove a order
  Future<void> removeOrder(int id) async {
    try {
      final Database dbClient = await initDb();
      await dbClient.delete(cd.cartTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('....ERROR! Not able to remove pack data to database $e');
    }
  }

// remove all orders
  Future<void> emptyCart() async {
    try {
      final Database dbClient = await initDb();
      await dbClient.delete(cd.cartTable);
    } catch (e) {
      print('....ERROR! Not able to remove all orders $e');
    }
  }

// Add a new type of sweet
  Future<void> addSweet(SweetModel item) async {
    try {
      final Database dbClient = await initDb();
      await dbClient.insert(cd.sweetNamesTable, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('....ERROR! Not able to save sweet data to database \n$item \n$e');
    }
  }

// Remove a sweet
  Future<void> removeSweet(int id) async {
    try {
      final Database dbClient = await initDb();
      await dbClient
          .delete(cd.sweetNamesTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('....ERROR! Not able to remove sweet data to database $e');
    }
  }

// Add Mock Data, pack size and sweet description
  Future<void> addMockData() async {
    try {
      List<PackModel> mockPacks = [
        new PackModel(size: 5000),
        new PackModel(size: 2000),
        new PackModel(size: 1000),
        new PackModel(size: 500),
        new PackModel(size: 250),
      ];
      for (PackModel pack in mockPacks) {
        await addPack(pack); // save packs to database
      }

      SweetModel sweetie = new SweetModel(
          id: 1,
          name: cd.mockSweetName,
          description:
              "`${cd.mockSweetDescription}`"); // in back ticks incase of sql keywords inside text

      await addSweet(sweetie); // add sweet description to database
    } catch (e) {
      print('....ERROR! Not able to add mock data to database $e');
    }
  }
}
