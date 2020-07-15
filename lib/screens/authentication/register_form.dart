import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scout_tracker/services/auth.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();

  bool _obscurePasswordLogin = true;

  bool _autoValidateEmail = false;
  bool _autoovalidatePassword = false;

  bool _isLoading = false;

  int _rank = 0;
  String _email;
  String _pass;

  //FocusNode _firstNameFocus;

  final List<String> ranks = [
    'No Rank',
    'Scout',
    'Tenderfoot',
    'Second Class',
    'First Class',
    'Star',
    'Life'
  ];

  final List<Widget> rankIcons = [
    Icon(Icons.not_interested),
    Icon(Icons.child_care),
    Icon(Icons.explore),
    Icon(Icons.looks_two),
    Icon(Icons.looks_one),
    Icon(Icons.star),
    Icon(Icons.favorite),
  ];

  @override
  void initState() {
    super.initState();
    //_firstNameFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //_firstNameFocus.dispose();
    super.dispose();
  }

  Widget _buildButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8, // soften the shadow
            spreadRadius: 1, //extend the shadow
            offset: Offset(
              0, // Move to right 10  horizontally
              3, // Move to bottom 10 Vertically
            ),
          )
          // BoxShadow(
          //   color: Colors.amber[200],
          //   offset: Offset(1, 6),
          //   blurRadius: 10,
          //   spreadRadius: 1,
          // ),
          // BoxShadow(
          //   color: Colors.redAccent,
          //   offset: Offset(1, 6),
          //   blurRadius: 10,
          //   spreadRadius: 1,
          // ),
        ],
        gradient: new LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.amber[200],
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0, 1],
            tileMode: TileMode.clamp),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(80)),
          onTap: () async {
            if (_registerFormKey.currentState.validate()) {
              _registerFormKey.currentState.save();
              print(_email);
              print(_pass);
              print(_rank);
              setState(() => _isLoading = true);
              dynamic result = await AuthService()
                  .register(email: _email, pass: _pass, rank: _rank);
              if (result == null) setState(() => _isLoading = false);
            } else {
              print('invalid');
              setState(() {
                _autoValidateEmail = true;
                _autoovalidatePassword = true;
              });
            }
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.redAccent,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10, // soften the shadow
                spreadRadius: 1, //extend the shadow
                offset: Offset(
                  0, // Move to right 10  horizontally
                  3, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  autovalidate: _autoValidateEmail,
                  validator: (email) => EmailValidator.validate(email)
                      ? null
                      : "Invalid email address",
                  onSaved: (email) => _email = email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.mail,
                      color: Colors.black,
                    ),
                    hintText: "Email Address",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: Colors.grey[400],
                ),
                TextFormField(
                  autovalidate: _autoovalidatePassword,
                  validator: (password) {
                    Pattern pattern =
                        r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(password))
                      return 'Password must container letters, numbers and >6 characters';
                    else
                      return null;
                  },
                  onSaved: (password) => _pass = password,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  obscureText: _obscurePasswordLogin,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _obscurePasswordLogin
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _obscurePasswordLogin = !_obscurePasswordLogin;
                        });
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: Colors.grey[400],
                ),
                Row(
                  children: [
                    rankIcons[_rank],
                    Expanded(
                      child: Slider(
                        value: _rank.toDouble(),
                        onChanged: (newRank) {
                          setState(() => _rank = newRank.toInt());
                          HapticFeedback.selectionClick();
                        },
                        inactiveColor: Colors.grey[200],
                        activeColor: Colors.redAccent,
                        divisions: 6,
                        min: 0,
                        max: 6,
                        label: '${ranks[_rank]}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: !_isLoading
                          ? _buildButton()
                          : SpinKitThreeBounce(
                              color: Colors.deepOrangeAccent,
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*

first/last name input fields

Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (first) {
                          return first.isEmpty ? 'Invalid First Name' : null;
                        },
                        onSaved: (first) => _firstName = first,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintText: "First Name",
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        validator: (last) {
                          return last.isEmpty ? 'Invalid Last Name' : null;
                        },
                        onSaved: (last) => _lastName = last,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Last Name",
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: Colors.grey[400],
                ),


                */