import 'package:flutter/material.dart';
import '../model/user.dart';
import '../globals.dart' as globals;

class Register extends StatefulWidget {
  @override
  RegisterState createState() {

    return RegisterState();
  }

}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  // var _password1 = '';
  final useridController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  // final UserProvider up = UserProvider();

  bool userExist = false;

  int spaceValidate(String txt){
    int space = 0;
    for(int i = 0;i < txt.length;i++){
      if(txt[i] == ' '){
        space += 1;
      }
    }
    return space;
  }

  bool isNum(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Register"),
        centerTitle: true,
        automaticallyImplyLeading: false
      ),
      body: Container(
        padding:EdgeInsets.all(25),
        child:Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration : InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'User Id'
                ),
                controller: useridController,
                onSaved: (value) => print(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  // 6-12 char
                  else if (value.length < 6 || value.length > 12){
                    return "กรุณากรอกข้อมูลให้ถูกต้อง";
                  } else if (userExist) {
                    return "มี User Id นี้แล้ว";
                  }
                },
              ),
              TextFormField(
                decoration : InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: 'Name'
                ),
                controller: nameController,
                onSaved: (value) => print(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  // 6-12 char
                  if(spaceValidate(value) != 1){
                    return "กรุณากรอกข้อมูลให้ถูกต้อง";
                  }
                },
              ),
              TextFormField(
                decoration : InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Age'
                ),
                controller: ageController,
                onSaved: (value) => print(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  else if (!isNum(value) || int.parse(value) < 10 || int.parse(value) > 80) {
                    return "กรุณากรอกข้อมูลให้ถูกต้อง";
                  } 
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: "Password",
                ),
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                onSaved: (value) => print(value),
                validator: (value){
                  // this._password1 = value;
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  if (value.length <= 6) {
                    return "ความยาวต้องมาก 6 ตัว";
                  }
                },
              ),
              
              Container(
                padding: EdgeInsets.only(top:15),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("REGISTER NEW ACCOUNT"),
                  splashColor: Colors.green,
                  onPressed: () async {
                    _formKey.currentState.validate();
                    await globals.up.open("user.db");
                    User user = User();
                    Future<List<User>> existUsers = globals.up.getAllUser();
                    user.userid = useridController.text;
                    user.name = nameController.text;
                    user.age = ageController.text;
                    user.password = passwordController.text;

                    Future isExistUser(User user) async {
                      var users = await existUsers;
                      for(var i=0; i < users.length;i++){
                        if (user.userid == users[i].userid){
                          this.userExist = true;
                          break;
                        }
                      }
                    }

                    await isExistUser(user);

                    if(_formKey.currentState.validate()) {
                      //to sqlite

                      if (await userExist != true ) {
                        userExist = false;
                        //inserting
                        await globals.up.insertUser(user);
                        user.userid = '';
                        user.name = '';
                        user.age = '';
                        user.password = '';
                        Navigator.pushNamed(context, '/');
                      }
                    }
                    Future showAllUser() async {
                      var users = await existUsers;
                      for(var i=0; i < users.length;i++){
                        print(users[i]);
                        }
                      }

                    showAllUser();
                    // print(CurrentUser.whoCurrent());
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}