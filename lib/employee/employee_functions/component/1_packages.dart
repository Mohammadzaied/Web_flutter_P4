import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';

late package_edit pk_select;

class package_edit extends StatefulWidget {
  final String photo_cus;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String from;
  final String to;
  final String name;
  final String
      status; // status for accepted orders  if the order status is accept,reject or above to edit status , but new orders should not be here
  final String driver;
  final int id;

  package_edit({
    super.key,
    required this.photo_cus,
    required this.from,
    required this.to,
    required this.name,
    required this.package_type,
    required this.id,
    required this.status,
    required this.driver,
  });

  @override
  State<package_edit> createState() => _package_editState();
}

class _package_editState extends State<package_edit> {
  @override
  void initState() {
    super.initState();
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
                              image: AssetImage(widget.photo_cus))),
                    ),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package Type : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.package_type == 0
                                ? 'Package Delivery '
                                : 'Package Received ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
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
                        text: 'Package status: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.status}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Driver: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.driver.isNotEmpty
                                ? ' ${widget.driver}'
                                : '....',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Customer name: ',
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
                        text: widget.package_type == 0 ? 'to: ' : 'from: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.package_type == 0
                                ? '${widget.to}'
                                : '${widget.from}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    // Spacer(),
                    // Text.rich(TextSpan(
                    //     text: 'Package size : ',
                    //     style: TextStyle(fontSize: 12, color: Colors.grey),
                    //     children: <InlineSpan>[
                    //       TextSpan(
                    //         text: widget.package_size == 0
                    //             ? 'Document'
                    //             : widget.package_size == 1
                    //                 ? 'Small'
                    //                 : widget.package_size == 2
                    //                     ? 'Meduim'
                    //                     : 'Large',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       )
                    //     ])),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: MaterialButton(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Package",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                pk_select = widget;
                              });
                              GoRouter.of(context).go('/edit_package');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
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
                                "Delete",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
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
