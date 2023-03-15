import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presintation/models/firebase_data.dart';
import 'package:http/http.dart' as http;

class GetTodo with ChangeNotifier {

  List<FirebaseData> _dataUser = [];
  List<FirebaseData> get dataUser {
    return _dataUser;
  }


  
  
  Future<void> getTodo()async{
    _dataUser = [];
    final fragment = await FirebaseAuth.instance.currentUser!.getIdToken();
    Uri url = Uri.parse(
      'https://presintation-2530e-default-rtdb.firebaseio.com/todo.json?auth=$fragment&orderBy="creatorId"&equalTo="${FirebaseAuth.instance.currentUser!.uid}"',
    );
    try{
      final response = await http.get(url);
      final Map data = jsonDecode(response.body);
     data.forEach((key, value) {
      _dataUser.add( FirebaseData.dataFromJson(value, key));
     });
    }on FirebaseException catch (error){
      throw error.message!;
    }
  }
}
