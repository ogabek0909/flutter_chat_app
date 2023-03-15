import 'package:flutter/material.dart';
import 'package:presintation/models/firebase_data.dart';
import 'package:presintation/providers/get_todo.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

class TodoListAppBarWidget extends StatelessWidget {
  final Category categoryItem;
  TodoListAppBarWidget({
    super.key,
    required this.categoryItem,
  });

  late List<FirebaseData> item = [];
  @override
  Widget build(BuildContext context) {
    if (categoryItem.title == 'All') {
      item = Provider.of<GetTodo>(context, listen: false).dataUser;
    } else {
      item = Provider.of<GetTodo>(context, listen: false)
          .dataUser
          .where((element) => element.category == categoryItem.title)
          .toList();
    }
    return FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(87, 134, 255, 1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: const Text('delete all'),
                          onTap: () {
                            print('all of them is deleted');
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('hi'),
                          onTap: () {
                            print('hi');
                          },
                        ),
                      ];
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: categoryItem.icon,
                      ),
                    ),
                  ),
                  Text(
                    categoryItem.title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${item.length} tasks",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
