import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class sign_in extends StatefulWidget {
  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  bool passwordVisible = false;
  GlobalKey<FormState> formState = GlobalKey();
  var responceBody;
  String? userName;
  bool isLoginFaild = false;
  String? password;

  Future postSignin() async {
    var url = urlStarter + "/users/signin";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "userName": userName,
          "password": password,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['result'] != "user not found") {
      print(responceBody['user']['userName']);
      GetStorage().write("Fname", responceBody['user']['Fname']);
      GetStorage().write("password", responceBody['user']['password']);
      GetStorage().write("Lname", responceBody['user']['Lname']);
      GetStorage().write("userName", responceBody['user']['userName']);
      GetStorage().write("email", responceBody['user']['email']);
      GetStorage().write("phoneNumber", responceBody['user']['phoneNumber']);
      GetStorage().write("userType", responceBody['user']['userType']);
      GetStorage().write("city", responceBody['user']['city']);
      GetStorage().write("town", responceBody['user']['town']);
      GetStorage().write("street", responceBody['user']['street']);
      GetStorage().write("url", responceBody['user']['url']);
      if (responceBody['user']['userType'] == "employee")
        GoRouter.of(context).go('/new_orders');
      else {
        print("not allowed");
        showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialog(
                "Not allowed",
                "You cannot access your account using the web application. Please log in from the mobile application",
                context);
          },
        );
      }
    } else {
      setState(() {
        isLoginFaild = true;
      });

      formState.currentState!.validate();
      showValidationMessage("Incorrect username or password");
      print("user not found");
    }
    return responceBody;
  }

  void showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GetStorage().erase();
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 90,
              child: HeaderWidget(90),
            ),
            Container(
              height: 160,
              child: Image(
                image: AssetImage("assets/fff.png"),
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primarycolor),
                    ),
                    Text(
                      "Log In to your account",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: 400,
                        child: Form(
                            key: formState,
                            child: Column(
                              children: [
                                TextFormField(
                                  expands: false,
                                  onSaved: (newValue) {
                                    userName = newValue;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please the enter username";
                                    }
                                    if (isLoginFaild) {
                                      return "Incorrect username or password";
                                    }
                                    return null;
                                  },
                                  decoration: theme_helper().text_form_style(
                                    'Username',
                                    'Enter your username',
                                    Icons.person,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  onSaved: (newValue) {
                                    password = newValue;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                    if (isLoginFaild) {
                                      return "Incorrect username or password";
                                    }
                                    return null;
                                  },
                                  obscureText: !passwordVisible,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: primarycolor,
                                    ),
                                    labelText: 'Password',
                                    hintText: 'Enter your user Password',
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        child: Text("Forgot your password?"),
                                        onTap: () => GoRouter.of(context)
                                            .go('/Forget_Password')),
                                  ),
                                ),
                                Container(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color: primarycolor,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        "Log in",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      isLoginFaild = false;
                                      if (formState.currentState!.validate()) {
                                        formState.currentState!.save();
                                        postSignin();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
