import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/add_manager.dart';
import 'package:flutter_application_1/admin/all_mangers.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/admin/problem_content.dart';
import 'package:flutter_application_1/admin/problems.dart';
import 'package:flutter_application_1/drawer/drawer.dart';
import 'package:flutter_application_1/drawer/drawer_function/TechnicalReport.dart';
import 'package:flutter_application_1/drawer/drawer_function/change_password.dart';
import 'package:flutter_application_1/drawer/drawer_function/edit_profile.dart';
import 'package:flutter_application_1/drawer/drawer_function/send_report.dart';
import 'package:flutter_application_1/employee/employee_functions/3_all_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/4_assign_order.dart';
import 'package:flutter_application_1/employee/employee_functions/6_distribution_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/2_create_order.dart';
import 'package:flutter_application_1/employee/employee_functions/7_edit_driver.dart';
import 'package:flutter_application_1/employee/employee_functions/8_edit_page.dart';
import 'package:flutter_application_1/employee/employee_functions/1_new_orders.dart';
import 'package:flutter_application_1/employee/employee_functions/5_receiving_money.dart';
import 'package:flutter_application_1/employee/employee_functions/9_track-package.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/employee/employee_functions/component/7_location_new_order.dart';
import 'package:flutter_application_1/employee/employee_functions/data.dart';
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
late Widget widget8;
late TabController TabController_;
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> shellNavigatorKey2 =
    GlobalKey<NavigatorState>(debugLabel: 'shell2');

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
  void initState() {
    widget1 = all_orders();
    widget2 = new_order();
    widget3 = create_order(
      title: 'Create order',
    );
    widget4 = assign_order();
    widget5 = receiving_money();
    widget6 = edit_driver();
    widget7 = distribution_orders();
    widget8 = track_p(isSearchBox: true, packageId: 00000000);
    TabController_ = TabController(length: 8, vsync: this);
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
            Tab(text: 'Tracking Packages'),
            Tab(text: 'Edit driver information'),
          ],
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
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
      GoRouter.of(context).go('/track_package');

      break;
    case 7:
      GoRouter.of(context).go('/edit_driver');

      break;
  }
}

/////////////////////////////////

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

    GoRoute(
        path: '/report',
        builder: (BuildContext context, GoRouterState state) {
          return TechnicalReport();
        }),
    GoRoute(
        path: '/send_report',
        builder: (BuildContext context, GoRouterState state) {
          return SendTechnicalReport();
        }),
    // GoRoute(
    //   path: '/show_report',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return TechnicalReportDetails(
    //       id: int.parse(state.uri.queryParameters['id'].toString()),
    //     );
    //   },
    // ),
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
          path: '/location',
          builder: (BuildContext context, GoRouterState state) {
            return Location_p(
              Latefrom: double.parse(
                  state.uri.queryParameters['Latefrom'].toString()),
              longfrom: double.parse(
                  state.uri.queryParameters['Latefrom'].toString()),
              Lateto: double.parse(
                  state.uri.queryParameters['Latefrom'].toString()),
              longto: double.parse(
                  state.uri.queryParameters['Latefrom'].toString()),
            );
          },
        ),
        GoRoute(
          path: '/data',
          builder: (BuildContext context, GoRouterState state) {
            return data_show(
              id: int.parse(state.uri.queryParameters['id'].toString()),
            );
          },
        ),
        GoRoute(
          path: '/edit_driver',
          builder: (BuildContext context, GoRouterState state) {
            return widget6;
          },
        ),
        GoRoute(
          path: '/track_package',
          builder: (BuildContext context, GoRouterState state) {
            return widget8;
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
    ShellRoute(
      navigatorKey: shellNavigatorKey2,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return main_page_admin(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/all_manager',
          builder: (BuildContext context, GoRouterState state) {
            return all_managers();
          },
        ),
        GoRoute(
          path: '/Add_manager',
          builder: (BuildContext context, GoRouterState state) {
            return add_manager();
          },
        ),
        GoRoute(
          path: '/problem_reports',
          builder: (BuildContext context, GoRouterState state) {
            return problems();
          },
        ),
        GoRoute(
          path: '/problem',
          builder: (BuildContext context, GoRouterState state) {
            return problem_content(
              id: int.parse(state.uri.queryParameters['id'].toString()),
            );
          },
        ),
      ],
    ),
  ],
);
