import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/todo.dart';

class AddTodo with ChangeNotifier{
  Future<void> addTodo(Todo newTodo) async {
    final fragment = await FirebaseAuth.instance.currentUser!.getIdToken();
    Uri url = Uri.parse(
      'https://presintation-2530e-default-rtdb.firebaseio.com/todo.json?auth=$fragment',
    );
    try{
    await http.post(
      url,
      body: jsonEncode(
        {
          'title': newTodo.title,
          'description': newTodo.description,
          'date':newTodo.notificationDate.toIso8601String(),
          'isDone':newTodo.isDone,
          'category':newTodo.category,
          'creatorId': FirebaseAuth.instance.currentUser!.uid,
        },
      ),
    );
    }on FirebaseAuthException catch (error){
      throw error.message!;
    }
    notifyListeners();
  }
}