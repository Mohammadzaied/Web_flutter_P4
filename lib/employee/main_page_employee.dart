import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/common/drawer.dart';
import 'package:flutter_application_1/employee/drawer_function/change_password.dart';
import 'package:flutter_application_1/employee/drawer_function/edit_profile.dart';
import 'package:flutter_application_1/employee/employee_functions/3_all_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/4_assign_order.dart';
import 'package:flutter_application_1/employee/employee_functions/9_data.dart';
import 'package:flutter_application_1/employee/employee_functions/6_distribution_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/2_create_order.dart';
import 'package:flutter_application_1/employee/employee_functions/7_edit_driver.dart';
import 'package:flutter_application_1/employee/employee_functions/8_edit_page.dart';
import 'package:flutter_application_1/employee/employee_functions/1_new_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/5_receiving_money.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/sign_in_pages/2_forget_pass.dart';
import 'package:flutter_application_1/sign_in_pages/4_new_password.dart';
import 'package:flutter_application_1/sign_in_pages/1_sign_in.dart';
import 'package:flutter_application_1/sign_in_pages/3_verification.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';

late Widget widget1;
late Widget widget2;
late Widget widget3;
late Widget widget4;
late Widget widget5;
late Widget widget6;
late Widget widget7;

late TabController TabController_;

class main_page extends StatefulWidget {
  const main_page({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page>
    with SingleTickerProviderStateMixin {
  int counter_new = 0;
  int counter_assign = 0;

  void initState() {
    widget1 = all_orders(pk_all: buildMy_package_edit());
    widget2 = new_order();
    //counter_new = 2; //buildMy_new_orders().length;
    widget3 = create_order(
      title: 'Create order',
    );
    widget4 = assign_order(pk_assign: buildMy_assign_orders());
    counter_assign = buildMy_assign_orders().length;
    widget5 = receiving_money();
    widget6 = edit_driver();
    widget7 = distribution_orders();
    TabController_ = TabController(length: 7, vsync: this);
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
              GoRouter.of(context).go('/new_orders');
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
            Tab(text: 'New Orders'),
            Tab(text: 'Create Order'),
            Tab(text: 'Assign Orders'),
            Tab(text: 'All Orders '),
            Tab(text: 'Receiving Money'),
            Tab(text: 'Distribution orders'),
            Tab(text: 'Edit driver information'),
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
      GoRouter.of(context).go('/new_orders');
      break;
    case 1:
      GoRouter.of(context).go('/create_order');
      break;
    case 2:
      GoRouter.of(context).go('/assign_orders');
      break;
    case 3:
      GoRouter.of(context).go('/all_orders');
      break;
    case 4:
      GoRouter.of(context).go('/receiving_money');
      break;
    case 5:
      GoRouter.of(context).go('/distribution_orders');
      break;
    case 6:
      GoRouter.of(context).go('/edit_driver');

      break;
  }
}

/////////////////////////////////
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GoRouter Router_pages = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    //////////////////// route main pages

    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return sign_in();
        }),
    GoRoute(
        path: '/Verification',
        builder: (BuildContext context, GoRouterState state) {
          return Verification();
        }),
    GoRoute(
        path: '/Forget_Password',
        builder: (BuildContext context, GoRouterState state) {
          return ForgetPassword();
        }),
    GoRoute(
        path: '/New_Password',
        builder: (BuildContext context, GoRouterState state) {
          return NewPass();
        }),

    ///////////////////////////////////// route functions drawer
    GoRoute(
        path: '/change_pass',
        builder: (BuildContext context, GoRouterState state) {
          return chang_pass();
        }),

    GoRoute(
        path: '/edit_profile',
        builder: (BuildContext context, GoRouterState state) {
          return edit_profile();
        }),

    //////////////////// route main page employee
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return main_page(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/all_orders',
          builder: (BuildContext context, GoRouterState state) {
            return widget1;
          },
        ),
        GoRoute(
          path: '/edit_package',
          builder: (BuildContext context, GoRouterState state) {
            return edit_package(
              pk_edit: pk_select,
            );
          },
        ),
        GoRoute(
          path: '/new_orders',
          builder: (BuildContext context, GoRouterState state) {
            return widget2;
          },
        ),
        GoRoute(
          path: '/create_order',
          builder: (BuildContext context, GoRouterState state) {
            return widget3;
          },
        ),
        GoRoute(
          path: '/assign_orders',
          builder: (BuildContext context, GoRouterState state) {
            return widget4;
          },
        ),
        GoRoute(
          path: '/receiving_money',
          builder: (BuildContext context, GoRouterState state) {
            return widget5;
          },
        ),
        GoRoute(
          path: '/edit_driver',
          builder: (BuildContext context, GoRouterState state) {
            return widget6;
          },
        ),
        GoRoute(
          path: '/distribution_orders',
          builder: (BuildContext context, GoRouterState state) {
            return widget7;
          },
        ),
      ],
    ),
  ],
);
