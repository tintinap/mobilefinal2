import 'package:flutter/material.dart';
import "../model/user.dart";
import '../globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {

    return LoginState();
  }

}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final useridController = TextEditingController();
  final passwordController = TextEditingController();


  // UserProvider globals.up = UserProvider();

  bool userPasswordExist = false;

  String validatorDisplay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:EdgeInsets.all(25),
        child:Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Image.asset(
                "srcs/img.png", 
                height: 175,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  // labelText: "Email",
                  hintText: "User Id",
                ),
                keyboardType: TextInputType.emailAddress,
                controller: useridController,
                onSaved: (value) => print(value),
                validator: (value){
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }

                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  // labelText: "Password",
                  icon: Icon(Icons.lock),
                  hintText: "Password",
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: passwordController,
                onSaved: (value) => print(value),
                validator: (value){
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }

                },
              ),
              Text(
                validatorDisplay,style: TextStyle(color: Colors.red),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("LOGIN"),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    User dbUser = User();

                    _formKey.currentState.validate();
                    // await globals.up.open("user.db");
                    if (_formKey.currentState.validate()) {
                        User user = User();
                        Future<List<User>> existUsers = globals.up.getAllUser();
                        user.userid = useridController.text;
                        user.password = passwordController.text;
                        Future isExistUserAndPasswordValid(User user) async {
                          var users = await existUsers;
                          for(var i=0; i < users.length;i++){
                            if (user.userid == users[i].userid && user.password == users[i].password){
                              this.userPasswordExist = true;
                              break;
                            }
                          }
                        }

                        Future getNameUser(User user) async {
                          var users = await existUsers;
                          for(var i=0; i < users.length;i++){
                            if (user.userid == users[i].userid){
                                dbUser.name = users[i].name;
                              break;
                            }
                          }
                        }

                        await isExistUserAndPasswordValid(user);
                        await getNameUser(user);
                        if (userPasswordExist) {
                          userPasswordExist = false;
                          useridController.text = "";
                          passwordController.text = "";
                          validatorDisplay = '';
                          //share prefer
                          print("db ${dbUser.name}");
                          prefs.setString('Name', dbUser.name);
                          prefs.setString('UserId', dbUser.userid);
                          print('pref ${prefs.getString('Name')}');
                          Navigator.pushReplacementNamed(context, '/main');
                          //go to main
                        } else { //not valid
                          setState(() {
                           validatorDisplay = 'Invalid user or password'; 
                          });
                        }

                    };
                  },
                ),
              ),
              Container(
                child: FlatButton(
                  child: Text("Register New Account"),
                  onPressed:() {
                    Navigator.pushNamed(context, "/register");
                  },
                ),
                alignment: Alignment.bottomRight,
              )
            ],
          ),
        ),
      ),
    );
  }
}