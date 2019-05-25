import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String idColumn = "_id";
final String useridColumn = "userid";
final String nameColumn = "name";
final String ageColumn = "age";
final String passwordColumn = "password";
final String quoteColumn = "quote";

class User {
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;

  User();

  User.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.userid = map[useridColumn];
    this.name = map[nameColumn];
    this.age = map[ageColumn];
    this.password = map[passwordColumn];
    this.quote = map[quoteColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridColumn: userid,
      nameColumn: name,
      ageColumn: age,
      passwordColumn: password,
      quoteColumn: quote,
    };
    if (id != null) {
      map[idColumn] = id; 
    }
    return map;
  }

  @override
  String toString() { return 'id: ${this.id}, userid:  ${this.userid}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}'; }

}

class UserProvider {
  Database db;

  Future open(String path) async {
    print('opening');
    db = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
         /* await db.execute('''
      create table $userTable (
        $idColumn integer primary key autoincrement,
        $useridColumn text not null unique,
        $nameColumn text not null,
        $ageColumn text not null,
        $passwordColumn text not null,
        $quoteColumn text
      )
      ''');*/
          await db.execute('''
            CREATE TABLE $userTable (
              $idColumn integer primary key autoincrement,
              $useridColumn TEXT NOT NULL unique,
              $nameColumn TEXT NOT NULL,
              $ageColumn TEXT NOT NULL,
              $passwordColumn text NOT NULL,
              $quoteColumn text
            )
        ''');
    });
    print('db creadted');
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    print("inserted");
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
        columns: [idColumn, useridColumn, nameColumn, ageColumn, passwordColumn, quoteColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
        maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    print('deleting $id');
    return await db.delete(userTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    print("updating $user");
    return db.update(userTable, user.toMap(),
        where: '$idColumn = ?', whereArgs: [user.id]);
  }
  
  Future<List<User>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(userTable, columns: [idColumn, useridColumn, nameColumn, ageColumn, passwordColumn, quoteColumn]);
    List<User> userList = res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();

}