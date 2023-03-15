import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:presintation/models/category.dart';
import 'package:presintation/providers/get_todo.dart';
import 'package:presintation/screens/todo_list_screen.dart';
import 'package:presintation/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

import 'add_todo_screen.dart';

class OverviewScreen extends StatefulWidget {
  OverviewScreen({super.key});
  static const routeName = 'overview-screen';

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<Category> items = [
    Category(
      icon: const Icon(
        Icons.document_scanner,
        color: Colors.blue,
        size: 40,
      ),
      onPressed: (BuildContext context) {
        // context.go("/${TodoListScreen.routeName}");
      },
      tasks: '12 tasks',
      title: 'All',
    ),
    Category(
      icon: const Icon(
        Icons.work,
        color: Colors.orange,
        size: 40,
      ),
      onPressed: (BuildContext context) {},
      tasks: '14 tasks',
      title: 'Work',
    ),
    Category(
      icon: const Icon(
        Icons.accessibility_new_rounded,
        color: Colors.red,
        size: 40,
      ),
      onPressed: (BuildContext context) {},
      tasks: '6 tasks',
      title: "Habit",
    ),
    Category(
      icon: const Icon(
        Icons.travel_explore,
        color: Colors.green,
        size: 40,
      ),
      onPressed: (BuildContext context) {},
      tasks: '1 tasks',
      title: "Travel",
    ),
    Category(
      icon: const Icon(
        Icons.menu_book_sharp,
        color: Colors.indigo,
        size: 40,
      ),
      onPressed: (BuildContext context) {},
      tasks: '12 tasks',
      title: 'Study',
    ),
    Category(
      icon: const Icon(
        Icons.home,
        color: Colors.red,
        size: 40,
      ),
      onPressed: (BuildContext context) {},
      tasks: '14 tasks',
      title: 'Home',
    )
  ];
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<GetTodo>(context, listen: false);
    return FutureBuilder(
      future: service.getTodo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                size: 30,
                color: Color.fromARGB(255, 80, 77, 77),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: AlertDialog(
                title: const Text('Something went wrong!'),
                content: Text(snapshot.error.toString()),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          drawer: const DrawerWidget(),
          key: _key,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 13, left: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _key.currentState!.openDrawer();
                        },
                        child: const Icon(
                          Icons.menu,
                          size: 35,
                        ),
                      ),
                      // Text("HI, ")
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Lists',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        // mainAxisExtent: 86,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 19 / 20,
                      ),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          context.goNamed(
                            TodoListScreen.routeName,
                            extra: items[index],
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                offset: Offset(0.5, 1),
                                blurRadius: 3,
                                spreadRadius: 1,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                items[index].icon,
                                const Spacer(),
                                Text(
                                  items[index].title,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(items[index].title != "All"
                                    ? '${Provider.of<GetTodo>(context, listen: false).dataUser.where((element) => element.category == items[index].title).length} tasks'
                                    : '${Provider.of<GetTodo>(context, listen: false).dataUser.length} tasks'),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              onPressed: () {
                context.goNamed(AddTodoScreen.routeName);
              },
              child: const Icon(Icons.add, size: 45, color: Colors.white),
            ),
          ),
        );
      },
    );
    // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
  }
}
