import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer/drawer.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';

late TabController TabController_;

class main_page_admin extends StatefulWidget {
  const main_page_admin({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  State<main_page_admin> createState() => _main_page_adminState();
}

class _main_page_adminState extends State<main_page_admin>
    with SingleTickerProviderStateMixin {
  void initState() {
    TabController_ = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/all_manager');
            },
            child: Text(
              '${Titleapp}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: primarycolor,
        bottom: TabBar(
          onTap: (int idx) => _onItemTapped(idx, context),
          controller: TabController_,
          tabs: [
            Tab(text: 'All Managers'),
            Tab(text: 'Add Manager'),
          ],
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
      ),
      body: widget.child,
      drawer: CustomDrawer(),
    );
  }

  void dispose() {
    TabController_.dispose();
    super.dispose();
  }
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      GoRouter.of(context).go('/all_manager');
      break;

    case 1:
      GoRouter.of(context).go('/Add_manager');
      break;
  }
}

// /////////////////////////////////
// final GlobalKey<NavigatorState> _rootNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _shellNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'shell');
// final GoRouter Router_pages2 = GoRouter(
//   navigatorKey: _rootNavigatorKey,
//   initialLocation: '/',
//   debugLogDiagnostics: true,
//   routes: <RouteBase>[
//     //////////////////// route main pages

//     GoRoute(
//         path: '/',
//         builder: (BuildContext context, GoRouterState state) {
//           return sign_in();
//         }),
//     GoRoute(
//         path: '/Verification',
//         builder: (BuildContext context, GoRouterState state) {
//           return Verification();
//         }),
//     GoRoute(
//         path: '/Forget_Password',
//         builder: (BuildContext context, GoRouterState state) {
//           return ForgetPassword();
//         }),
//     GoRoute(
//         path: '/New_Password',
//         builder: (BuildContext context, GoRouterState state) {
//           return NewPass();
//         }),

//     ///////////////////////////////////// route functions drawer
//     GoRoute(
//         path: '/change_pass',
//         builder: (BuildContext context, GoRouterState state) {
//           return chang_pass();
//         }),

//     GoRoute(
//         path: '/edit_profile',
//         builder: (BuildContext context, GoRouterState state) {
//           return edit_profile();
//         }),

//     //////////////////// route main page employee
//     ShellRoute(
//       navigatorKey: _shellNavigatorKey,
//       builder: (BuildContext context, GoRouterState state, Widget child) {
//         return main_page_admin(child: child);
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: '/all_manager',
//           builder: (BuildContext context, GoRouterState state) {
//             return widget1;
//           },
//         ),
//         GoRoute(
//           path: '/delete_Manager',
//           builder: (BuildContext context, GoRouterState state) {
//             return widget2;
//           },
//         ),
//         GoRoute(
//           path: '/Add_manager',
//           builder: (BuildContext context, GoRouterState state) {
//             return widget3;
//           },
//         ),
//       ],
//     ),
//   ],
// );
