import 'package:apakly/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apakly/auth_globals.dart';

Future<bool> signup(
    String email, String password, String firstName, String lastName, bool newsletter) async {
  final String jsonstring = jsonEncode(<String, String>{
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'newsletter': newsletter.toString(),
    'role': 'listener',
  });

  final response = await http.post(
    Uri.parse("$apiUri/auth/signup"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200){
    await storage.write(key: 'recoveryPhrase', value: json.decode(response.body)['recoveryPhrase']);
    return true;
  } else {
     return false;
  }
}

Future<bool> isJwtValid() async {
  var jwt = await storage.read(key: 'jwt');

  if (jwt == null) {
    return false;
  }

  final response = await http.post(
    Uri.parse('$apiUri/auth/validatejwt'),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonEncode(<String, String>{'token': jwt}),
  );

  if (response.statusCode == 200) {
    // jwt valid
    userEmail = json.decode(response.body)['userData']['email'];
    userFirstName = json.decode(response.body)['userData']['firstName'];
    userLastName = json.decode(response.body)['userData']['lastName'];
    userCryptoAddress = json.decode(response.body)['userData']['address'];
    return true;
  } else {
    // jwt invalid
    return false;
  }
}

Future<int> login(String email, String password) async {
  final String jsonstring = jsonEncode(<String, String>{
    'email': email,
    'password': password,
    'origin': 'app',
  });

  final response = await http.post(
    Uri.parse("$apiUri/auth/login"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if (response.statusCode == 200) {
    // user is verified
    userEmail = json.decode(response.body)['userData']['email'];
    userFirstName = json.decode(response.body)['userData']['firstName'];
    userLastName = json.decode(response.body)['userData']['lastName'];
    userCryptoAddress = json.decode(response.body)['userData']['address'];
    await storage.write(key: 'jwt', value: jsonDecode(response.body)['token']);
    return 1;
  } else if (response.statusCode == 403) {
    // user is not verified
    return 2;
  } else {
    // no user registered
    return 0;
  }
}

Future<String> verify(String email, String code) async {
  final String jsonstring = jsonEncode(<String, String>{
    'email': email,
    'code': code,
  });

  final response = await http.post(
    Uri.parse('$apiUri/auth/verify'),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Verification failed!");
  }
}

Future<String> resendVerificationEmail(String email) async {
  final String jsonstring = jsonEncode(<String, String>{
    'email': email,
  });

  final response = await http.post(
    Uri.parse('$apiUri/auth/resendVerificationEmail'),
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

Future<String> changePassword(String email,String newPassword) async {
  var jwt = await storage.read(key: 'jwt');
  final String jsonstring = jsonEncode(<String, String>{
    'email': email,
    'password': newPassword,
    'token': jwt!
  });
  
  final response = await http.post(
    Uri.parse('$apiUri/auth/changepassword'),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200){
    return response.body;
  } else {
    throw Exception("Failed");
  }
}
