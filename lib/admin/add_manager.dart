import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';
import 'package:flutter_application_1/style/showDialogShared/show_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class add_manager extends StatefulWidget {
  @override
  State<add_manager> createState() => _add_managerState();
}

class _add_managerState extends State<add_manager> {
  Future postUsersAddDriver() async {
    var url = urlStarter + "/admin/addManager";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "userName": username,
          "Fname": f_name,
          "Lname": l_name,
          "email": email,
          "phoneNumber": phone,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    print(responceBody);
    if (responceBody['message'] == "failed") {
      List errors = responceBody['error']['errors'];
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().aboutDialogErrors(errors, context);
          });
    }
    if (responceBody['message'] == "done") {
      showDialog(
          context: context,
          builder: (context) {
            return show_dialog().alartDialogPushNamed(
                "Done!",
                "The Manager account is created successfully,\nNow Please ask the manager to reset his password in login page.",
                context,
                GetStorage().read("userType"));
          });
    }
    return responceBody;
  }

  bool isUsernameTaken = false;
  bool isEmailTaken = false;
  final GlobalKey<FormFieldState<String>> _usernameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  Future<void> fetchData(String userName) async {
    var url = urlStarter + "/users/isAvailableUserName?userName=" + userName;
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 409) {
      setState(() {
        isUsernameTaken = true;
      });
    } else {
      setState(() {
        isUsernameTaken = false;
      });
    }
    _usernameKey.currentState!.validate();
  }

  Future<void> fetchDataEmail(String email) async {
    var url = urlStarter + "/users/isAvailableEmail?email=" + email;
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 409) {
      setState(() {
        isEmailTaken = true;
      });
    } else {
      setState(() {
        isEmailTaken = false;
      });
    }
    _emailKey.currentState!.validate();
  }

  GlobalKey<FormState> formState5 = GlobalKey();
  String? f_name;
  String? l_name;
  String? phone;
  String? username;
  String? email;

  @override
  void initState() {
    setState(() {
      TabController_2.index = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 60,
            child: HeaderWidget(60),
          ),
          Center(
            child: Container(
              width: 500,
              //padding: const EdgeInsets.all(top: 20),
              child: Form(
                  key: formState5,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: theme_helper().text_form_style(
                            "Manager name",
                            "Enter The manager's fisrt name",
                            Icons.person),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter manager's first name";
                        },
                        onSaved: (newValue) {
                          f_name = newValue;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: theme_helper().text_form_style(
                            "Manager name",
                            "Enter The manager's last name",
                            Icons.person),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter manager's last name";
                        },
                        onSaved: (newValue) {
                          l_name = newValue;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        key: _usernameKey,
                        decoration: theme_helper().text_form_style(
                            "The manager's username",
                            "Enter The manager's username",
                            Icons.person),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter manager's username";
                          if (isUsernameTaken)
                            return "This username is not available";
                        },
                        onChanged: (value) {
                          fetchData(value.toString());
                        },
                        onSaved: (newValue) {
                          email = newValue;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: theme_helper().text_form_style(
                            "The manager's Phone",
                            "Enter The manager's phone",
                            Icons.phone),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter manager's phone";
                        },
                        onSaved: (newValue) {
                          phone = newValue;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        key: _emailKey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: theme_helper().text_form_style(
                            "The manager's email",
                            "Enter The manager's email",
                            Icons.email),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter manager's email";
                          if (isEmailTaken) return "Used by another account";
                        },
                        onSaved: (newValue) {
                          email = newValue;
                        },
                        onChanged: (val) {
                          fetchDataEmail(val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: primarycolor,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Add Manager",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (formState5.currentState!.validate()) {
                              formState5.currentState!.save();
                              postUsersAddDriver();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
