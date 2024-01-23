// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/admin/main_page_admin.dart';
// import 'package:flutter_application_1/style/common/theme_h.dart';
// import 'package:flutter_application_1/style/header/header.dart';

// class create_order extends StatefulWidget {
//   final String name;
//   final String phone;
//   final String username;
//   final String email;
//   final String city;

//   create_order({
//     Key? key,
//     required this.name,
//     required this.phone,
//     required this.username,
//     required this.email,
//     required this.city,
//   }) : super(key: key);

//   @override
//   State<create_order> createState() => _create_orderState();
// }

// class _create_orderState extends State<create_order> {
//   List citylist = [
//     'Nablus',
//     'Tulkarm',
//     'Ramallah',
//     'Jenin',
//     'Qalqilya',
//     'Salfit',
//     'Hebron'
//   ];
//   String? toCity;
//   GlobalKey<FormState> formState5 = GlobalKey();
//   String? name;
//   String? phone;
//   String? username;
//   String? email;
//   String? city;

//   @override
//   void initState() {
//     setState(() {
//       TabController_.index = 1;
//     });
//     name = widget.name;
//     phone = widget.phone;
//     username = widget.username;
//     email = widget.email;
//     city = widget.city;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(children: [
//           Container(
//             height: 60,
//             child: HeaderWidget(60),
//           ),
//           Center(
//             child: Container(
//               width: 800,
//               child: Form(
//                   key: formState5,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 350,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'Name',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'Phone',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                                 TextFormField(
//                                   keyboardType: TextInputType.phone,
//                                   decoration: theme_helper().text_form_style(
//                                       "The sender's Phone",
//                                       "Enter The sender's phone",
//                                       Icons.phone),
//                                   validator: (value) {
//                                     String res = isValidPhone(value.toString());
//                                     if (!res.isEmpty) {
//                                       return res;
//                                     }
//                                     return null;
//                                   },
//                                   onSaved: (newValue) {
//                                     phone = newValue;
//                                   },
//                                 ),
//                                 Visibility(
//                                   visible: true,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(height: 10),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text(
//                                           'Email',
//                                           style: TextStyle(fontSize: 16),
//                                         ),
//                                       ),
//                                       TextFormField(
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         decoration: theme_helper()
//                                             .text_form_style(
//                                                 "The sender's email",
//                                                 "Enter The sender's email",
//                                                 Icons.email),
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return "Please enter sender's email";
//                                           }
//                                           if (!isValidEmail(value)) {
//                                             return 'Please enter a valid email address';
//                                           }
//                                           return null;
//                                         },
//                                         onSaved: (newValue) {
//                                           email = newValue;
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Spacer(),
//                           Container(
//                             width: 350,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'Recipient Name',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
                                
                                
                 
                      
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Center(
//                               child: Container(
//                                 child: MaterialButton(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(10.0)),
//                                   color: primarycolor,
//                                   child: Padding(
//                                     padding:
//                                         EdgeInsets.fromLTRB(40, 10, 40, 10),
//                                     child: Text(
//                                       "Save Package",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     if (formState5.currentState!.validate()) {
//                                       formState5.currentState!.save();
                                     
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//             ),
//         ]),
//       );
          
//   }
// }
