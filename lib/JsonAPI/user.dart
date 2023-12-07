class User {
  late int id;
  late String name;
  late String username;
  late String email;
  late String street;
  late String suite;
  late String city;
  late String zipcode;

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    username = json["username"];
    email = json["email"];
    street = json["address"]["street"];
    suite = json["address"]["suite"];
    city = json["address"]["city"];
    zipcode = json["address"]["zipcode"];
  }
}