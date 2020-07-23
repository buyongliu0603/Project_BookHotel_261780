import 'package:flutter/material.dart';
import 'package:lin_261780/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  double screenHeight;
  bool _isChecked = false;
  bool _validate = false;
  bool _isHidePassword = true;
  String name, email, phone, password;
  String urlRegister = "https://lintatt.com/bookhotels/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      title: 'Material App',
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
        height: 700,
        margin: EdgeInsets.only(top: screenHeight / 3.5),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          autovalidate: _validate,
          child: Column(
            children: <Widget>[
              Card(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextFormField(
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          validator: _validateName,
                          onSaved: (String val) {
                            name = val;
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                          )),
                      TextFormField(
                          controller: _emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          onSaved: (String val) {
                            email = val;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          )),
                      TextFormField(
                          controller: _phoneditingController,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                          onSaved: (String val) {
                            phone = val;
                          },
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            icon: Icon(Icons.phone),
                          )),
                      TextFormField(
                        obscureText: _isHidePassword,
                        controller: _passEditingController,
                        validator: _validatePass,
                        onSaved: (String val) {
                          password = val;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  _togglePasswordVisibility();
                                },
                                child: Icon(
                                  _isHidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _isHidePassword
                                      ? Colors.grey
                                      : Colors.green,
                                ))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Checkbox(
                            value: _isChecked,
                            checkColor:
                                Colors.yellowAccent, // color of tick Mark
                            activeColor: Colors.green,
                            onChanged: (bool value) {
                              _onChange(value);
                            },
                          ),
                          GestureDetector(
                            onTap: _showEULA,
                            child: Text('I Agree to Terms  ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 115,
                            height: 50,
                            child: Text('Sign up'),
                            color: Colors.green,
                            textColor: Colors.white,
                            elevation: 10,
                            onPressed: _onRegister,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already register? ", style: TextStyle(fontSize: 16.0)),
                  GestureDetector(
                    onTap: _loginScreen,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.hotel,
            size: 40,
            color: Colors.blue,
          ),
          Text(
            " BookHotel",
            style: TextStyle(
                fontSize: 36, color: Colors.blue, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loginScreen() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Are you sure?"),
              content: new Text("Do you want to cancel register account?"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Yes'),
                  textColor: Colors.green,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                  },
                ),
                new FlatButton(
                  child: new Text("No"),
                  textColor: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("Name $name");
        print("Email $email");
        print("Phone $phone");
        print("Password $password");
      } else {
        setState(() {
          _validate = true;
        });
      }

      //savepref(value);
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and lintatt This EULA agreement governs your acquisition and use of our BookHotel software (Software) directly from lintatt or indirectly through a lintatt authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the BookHotel software. It provides a license to use the BookHotel software and contains warranty information and liability disclaimers. If you register for a free trial of the BookHotel software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the BookHotel software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Slumberjer herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for BookHotel. lintatt shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of lintatt. lintatt reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  String _validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The name is required';
    } else if (value.length < 4) {
      return "At least 4 character";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The email is required';
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String _validatePhone(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The phone No. is required';
    } else if (value.length != 10) {
      return "Phone No. must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Phone No. must be digits";
    }
    return null;
  }

  String _validatePass(String value) {
    String pattern = r'(?=.*?[#?!@$%^&*-])';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'The password is required';
    } else if (value.length < 4) {
      return "The password need at 4 character";
    } else if (value.length > 16) {
      return "The password need less than 16 character";
    } else if (!regExp.hasMatch(value)) {
      return "Password not valid";
    }
    return null;
  }
}
