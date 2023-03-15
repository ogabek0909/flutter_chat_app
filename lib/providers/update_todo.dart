import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateTodo with ChangeNotifier {

  bool _isDone = false;
  bool get isDone{
    return _isDone;
  }

  

  Future updateTodo(
    String id,
  ) async {
    final fragment = await FirebaseAuth.instance.currentUser!.getIdToken();
    Uri url = Uri.parse(
      'https://presintation-2530e-default-rtdb.firebaseio.com/todo/$id.json?auth=$fragment',
    );
    http.patch(
      url,
      body: jsonEncode(
        {},
      ),
    );
  }
}
