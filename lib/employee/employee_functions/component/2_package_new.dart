import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class package_new extends StatefulWidget {
  final String photo_cus;
  final String from;
  final String to;
  final int id;
  final int price;
  final String name;
  final int package_size; //0 doc  , 1 small ,2 meduim , 3 large
  final double Latefrom;
  final double longfrom;
  final double Lateto;
  final double longto;
  final Function() refreshdata;

  package_new({
    super.key,
    required this.photo_cus,
    required this.package_size,
    required this.from,
    required this.to,
    required this.name,
    required this.id,
    required this.price,
    required this.refreshdata,
    required this.Latefrom,
    required this.longfrom,
    required this.Lateto,
    required this.longto,
  });

  @override
  State<package_new> createState() => _package_newState();
}

class _package_newState extends State<package_new> {
  String selecteddriver = '';
  String reason = '';
  final formGlobalKey = GlobalKey<FormState>();

  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");

  Future post_accepet_order(int id) async {
    var url = urlStarter + "/employee/acceptPackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      widget.refreshdata();
    }
  }

  Future post_reject_order(int id) async {
    var url = urlStarter + "/employee/rejectPackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id,
          "comment": reason
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      widget.refreshdata();
    }
  }

  @override
  Widget build(BuildContext) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          splashColor: primarycolor.withOpacity(0.6),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.photo_cus,
                                scale: 1,
                                headers: {
                                  'ngrok-skip-browser-warning': 'true'
                                }),
                          )),
                    ),
                    // Spacer(),
                    // Text.rich(TextSpan(
                    //     text: 'Package Type : ',
                    //     style: TextStyle(fontSize: 12, color: Colors.grey),
                    //     children: <InlineSpan>[
                    //       TextSpan(
                    //         text:
                    //              'Package Delivery '
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       )
                    //     ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package ID : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Sender Name : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.name}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),

                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'from: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '${widget.from}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),

                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'to: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '${widget.to}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package size : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.package_size == 0
                                ? 'Document'
                                : widget.package_size == 1
                                    ? 'Small'
                                    : widget.package_size == 2
                                        ? 'Meduim'
                                        : 'Large',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package price: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '${widget.price}₪',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: MaterialButton(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                )),
                            onPressed: () {
                              GoRouter.of(context).go(
                                  '/location?Latefrom=${widget.Latefrom}&longfrom=${widget.longfrom}&Lateto=${widget.Lateto}&longto=${widget.longto}');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Location_p(
                              //             Latefrom: widget.Latefrom,
                              //             longfrom: widget.longfrom,
                              //             Lateto: widget.Lateto,
                              //             longto: widget.longto)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: MaterialButton(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              post_accepet_order(widget.id);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: MaterialButton(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        // Customize the border color
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              if (formGlobalKey.currentState!
                                                  .validate()) {
                                                formGlobalKey.currentState!
                                                    .save();
                                                post_reject_order(widget.id);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text(
                                              "Reject Package",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            )),
                                      ],
                                      title: Text("Reject Package"),
                                      content: Container(
                                        width: 500,
                                        child: Form(
                                          key: formGlobalKey,
                                          child: TextFormField(
                                            onSaved: (newValue) {
                                              reason = newValue!;
                                            },
                                            maxLines: 5,
                                            validator: (val) {
                                              if (val!.isEmpty)
                                                return "Please Enter Reason";
                                            },
                                            decoration: InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        20),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        20),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade400)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    borderSide: BorderSide(color: Colors.red, width: 2)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Enter the Reason'),
                                          ),
                                        ),
                                      ),
                                      titleTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      contentTextStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      backgroundColor: primarycolor,
                                    );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                    //Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
