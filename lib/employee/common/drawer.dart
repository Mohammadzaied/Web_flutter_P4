import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  String username = GetStorage().read("userName");
  String email = GetStorage().read("email");
  var imgUrl = urlStarter +
      '/image/' +
      GetStorage().read("userName") +
      GetStorage().read("url");
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Drawer(
        elevation: 0,
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: primarycolor.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                accountName: Text(
                  '${username}',
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text(
                  '${email}',
                  style: TextStyle(fontSize: 14),
                ),
                currentAccountPicture: CachedNetworkImage(
                  imageUrl: imgUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/default.jpg'),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.person,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).go('/edit_profile');
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.lock,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Change password",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).go('/change_pass');
                  //Navigator.pushNamed(context, '/change_password');
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.help,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Help",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(
                color: Colors.grey,
                height: 5,
                thickness: 1,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: Icon(
                  Icons.logout,
                  color: primarycolor,
                  size: 30,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  GoRouter.of(context).go('/');
                  //Navigator.pushNamed(context, '/sign_in');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
