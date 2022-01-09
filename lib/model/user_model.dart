import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class UserModel{
  int id=0;
  String? name;
  int? age;

  UserModel({this.id = 0, required this.name, required this.age});
}