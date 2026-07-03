import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

Future<String> sendPasswordResetEmail(String mail) async {
  final String jsonstring = jsonEncode(<String, String>{
    'email': mail,
  });


  final response = await http.post(
    Uri.parse('$apiUri/token/sendpasswordreset'),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Failed!");
  }
}

Future<String> setNewPassword(String token,String password) async{
  final String jsonString = jsonEncode(<String, String>{
    'token': token,
    'password': password
  });

  final response = await http.post(
    Uri.parse('$apiUri/token/passwordreset'),
    headers: <String,String>{
      'Content-type': 'application/json',
    },
    body: jsonString,
  );

  if(response.statusCode == 200){
    return "Passwort wurde erfolgreich geändert!";
  }
  else if(response.statusCode == 500){
    return response.body;
  }else {
    throw Exception("Failed!");
  }
}

Future<bool> doesTokenExist(String token) async{
  final String jsonString = jsonEncode(<String, String>{
    'token': token
  });

  final response = await http.post(
    Uri.parse(apiUri + '/token/checkToken'),
    headers: <String,String>{
      'Content-type': 'application/json',
    },
    body: jsonString
  );

  if(response.statusCode == 200){
    return true;
  } else {
    return false;
  }
}