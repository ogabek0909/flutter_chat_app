import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseData with ChangeNotifier{
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime date;
  bool isDone;
  FirebaseData({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    this.isDone = false,
    
  });

  Future<void> toggleDoneStatus() async {
    final oldValue = isDone;
    isDone = !isDone;
    notifyListeners();
    final fragment = await FirebaseAuth.instance.currentUser!.getIdToken();
    Uri url = Uri.parse(
      'https://presintation-2530e-default-rtdb.firebaseio.com/todo/$id.json?auth=$fragment',
    );
    final response =await http.patch(
      url,
      body: jsonEncode(
        {
          "isDone":isDone,
        },
      ),
    );
    if(response.statusCode >= 400){
      isDone = oldValue;
      notifyListeners();
    }
  }


  factory FirebaseData.dataFromJson(Map data, String id) {
    return FirebaseData(
      id: id,
      title: data['title'],
      category: data['category'],
      date: DateTime.parse(data['date']),
      description: data['description'],
      isDone: data['isDone'],
    );
  }
}
