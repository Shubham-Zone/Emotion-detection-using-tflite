import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'DataModel.dart';

class ApiProvider extends ChangeNotifier{

  Future<List<Data>> fetchData() async{

    // Getting response from the api
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

    print(response.body);

    if(response.statusCode == 200){

      // Converting the json data to dart object
      final List<dynamic> data = jsonDecode(response.body)['data'];

      // Convert the dart object to Data model and store in list
      return data.map((user) => Data.fromJson(user)).toList();

    }else{

      throw Exception("Failed to load data");

    }
    
  }

  late Future<List<Data>> futureData;

  void storeDataToList(){

    futureData = fetchData();

  }


}