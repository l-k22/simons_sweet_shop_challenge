/* 
  Sweet Pack model
  'size' is a unique identifier it also acts as our pack size

  For this challenge could go without a model for the pack size since 
  it is simply an integer, however for future proofing if we wanted packs to be 
  more defined e.g if shop sells packs other than sweets, or add unique 
  sweet types e.g chocolate eclairs, gummies etc.
 */
class PackModel {
  final int size;

  PackModel({required this.size});

  Map<String, dynamic> toMap() {
    return {'size': size};
  }

  // PackModel.fromJson(Map json) : size = json['size'];
  // from the database value map we need the key value pair stored inside
  PackModel.fromMap(Map map) : size = map["size"] as int;

  @override
  String toString() {
    return 'Pack {size: $size}';
  }

  // // setter
  // set id(int id) {
  //   this._id = id;
  // }

  // set order(int order) {
  //   this._order = order;
  // }

  // set type(String type) {
  //   this._type = _type;
  // }

  // // getters
  // int get id => this._id;
  // int get order => this._order;
  // String get type => this._type;
}

// class Sweet {
//   int _id, size;
//   String name, color, type;
//   bool sugarFree, glutenFree;

//   Sweet(this._id, this.color, this.glutenFree, this.name, this.size,
//       this.sugarFree, this.type);
// }
