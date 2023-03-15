import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:presintation/models/category.dart';
import 'package:presintation/models/firebase_data.dart';
import 'package:presintation/providers/get_todo.dart';
import 'package:presintation/providers/update_todo.dart';
import 'package:presintation/widgets/todo_list_app_bar_widget.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  final Category item;
  const TodoListScreen({super.key, required this.item});
  static const routeName = 'todo-list-screen';

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late List<FirebaseData> userTodos = [];

  @override
  Widget build(BuildContext context) {
    if (widget.item.title == 'All') {
      userTodos = Provider.of<GetTodo>(context).dataUser;
    } else {
      userTodos = Provider.of<GetTodo>(context)
          .dataUser
          .where((element) => element.category == widget.item.title)
          .toList();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: MediaQuery.of(context).size.height / 3,
          automaticallyImplyLeading: false,
          flexibleSpace: TodoListAppBarWidget(
            categoryItem: widget.item,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: ListView.builder(
            itemCount: userTodos.length,
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: userTodos[index],
              child: taskItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskItem(int index) {
    return Card(
      child: ListTile(
        title: Text(
          userTodos[index].title,
        ),
        subtitle: Text(
          DateFormat.yMd().add_Hm().format(userTodos[index].date),
        ),
        trailing: Consumer<FirebaseData>(
          builder: (context, firebaseData, child) => Checkbox(
            value: firebaseData.isDone,
            onChanged: (value) {
              firebaseData.toggleDoneStatus();
            },
          ),
        ),
      ),
    );
  }
}
