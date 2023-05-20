class Password {
  int? id;
  late String name;
  late String password;

  //The id will be managed through the database
  Password(this.name, this.password);
  //Sembast database takes map object to insert and update data.

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

  Password.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    password = map['password'];
  }
}
