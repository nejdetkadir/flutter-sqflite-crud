class Person {
  int _id;
  String _name;
  String _bio;

  int get id => _id;

  set id(int value) => value;

  String get name => _name;

  set name(String value) => value;

  String get bio => _bio;

  set bio(String value) => value;

  Person(this._name, this._bio);
  Person.withID(this._id, this._name, this._bio);

  // map funcs
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["bio"] = _bio;
    return map;
  }

  Person.fromMap(Map<String, dynamic> map) {
    _id = map["id"];
    _name = map["name"];
    _bio = map["bio"];
  }
}
