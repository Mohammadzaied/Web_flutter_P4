import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer/drawer.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';

late TabController TabController_2;

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
    TabController_2 = TabController(length: 3, vsync: this);
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
          controller: TabController_2,
          tabs: [
            Tab(text: 'All Managers'),
            Tab(text: 'Add Manager'),
            Tab(text: 'Problem Reports'),
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
    TabController_2.dispose();
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
    case 2:
      GoRouter.of(context).go('/problem_reports');
      break;
  }
}
