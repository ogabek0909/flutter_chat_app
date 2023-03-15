import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presintation/models/todo.dart';
import 'package:presintation/providers/add_todo.dart';
import 'package:presintation/providers/get_todo.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});
  static const routeName = 'add-todo-screen';

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  DateTime? _notificationDate;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String dropValue = 'Work';

  Future<TimeOfDay?> time() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _notificationDate ?? DateTime.now(),
      ),
    );
  }

  void _picker() async {
    DateTime? nD = await showDatePicker(
      context: context,
      initialDate: _notificationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (nD == null) {
      return;
    }
    final nT = await time();
    if (nT == null) {
      return;
    }
    nD = DateTime(nD.year, nD.month, nD.day, nT.hour, nT.minute);
    setState(() {
      _notificationDate = nD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 14, left: 14),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'New Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  const Text(
                    'what are you planning?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 18),
                    child: TextField(
                      style: const TextStyle(fontSize: 21),
                      maxLines: 6,
                      controller: _descriptionController,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 35,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _notificationDate == null
                            ? 'Choose date'
                            : DateFormat.d()
                                .add_MMMM()
                                .add_Hm()
                                .format(_notificationDate!)
                                .toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _picker,
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.note_alt_sharp,
                        size: 35,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add your task\'s title',
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 35,
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Categories: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: DropdownButton(
                            value: dropValue,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            isExpanded: true,
                            iconSize: 42,
                            dropdownColor: Colors.white,
                            underline: const Divider(
                              endIndent: 0,
                              indent: 0,
                              height: 0,
                              thickness: 2,
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Work', child: Text('Work')),
                              DropdownMenuItem(
                                  value: 'Habit', child: Text('Habit')),
                              DropdownMenuItem(
                                  value: 'Travel', child: Text('Travel')),
                              DropdownMenuItem(
                                  value: 'Study', child: Text('Study')),
                              DropdownMenuItem(
                                  value: 'Home', child: Text('Home')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropValue = value!;
                              });
                            }),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_notificationDate == null ||
                                _titleController.text.isEmpty ||
                                _descriptionController.text.isEmpty) {
                              return;
                            }
                            final newTodo = Todo(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              notificationDate: _notificationDate!,
                              category: dropValue,
                            );
                            await Provider.of<AddTodo>(context, listen: false)
                                .addTodo(newTodo);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
