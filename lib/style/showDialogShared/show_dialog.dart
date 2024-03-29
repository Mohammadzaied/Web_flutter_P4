import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';

const String Titleapp = 'Package4U';

class show_dialog {
  AlertDialog alartDialog(
    String title,
    String content,
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(27.0), // Adjust the radius as needed
      ),
      title: Text(title),
      content: Text(content),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      backgroundColor: primarycolor,
      actions: [
        TextButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            //GoRouter.of(context).go('/all_manager');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog alartDialogPushNamed(
      String title, String content, BuildContext context, String name) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(27.0), // Adjust the radius as needed
      ),
      title: Text(title),
      content: Text(content),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      backgroundColor: primarycolor,
      actions: [
        TextButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            GoRouter.of(context).go('/all_manager');

            //GoRouter.of(context).go(name);
          },
        ),
      ],
    );
  }

  AlertDialog aboutDialogErrors(List errors, BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //GoRouter.of(context).go('/all_manager');
            },
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      ],
      title: Text("Validation Error"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              child: Text("*${errors[index]['msg']}"),
              margin: EdgeInsets.only(bottom: 20),
            );
          },
          itemCount: errors.length,
        ),
      ),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      backgroundColor: primarycolor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(27.0), // Adjust the radius as needed
      ),
    );
  }
}
