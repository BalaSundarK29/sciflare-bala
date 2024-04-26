import 'package:sciflare/src/utils/utils.dart';

class UserModel {
  int id = 0;
  String name = '';
  String mobile = '';
  String email = '';
  String gender = '';

  UserModel();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnPhone: mobile,
      columnEmail: email,
      columnGender: gender
    };
    map[columnId] = id;
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = 0;
    name = map[columnName];
    mobile = map[columnPhone];
    email = map[columnEmail];
    gender = map[columnGender];
  }
}
