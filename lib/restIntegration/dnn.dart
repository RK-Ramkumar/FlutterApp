import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Dnn> fetchAlbum(String msg) async {
  print('request frame');
  final response = await http.get('https://127.0.0.1:5000/'+msg);
  //final response = await http.post('http://127.0.0.1:5000/',body: {'body':msg}).then((http.Response response) {
    //return response;
  //});
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Dnn.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


class Dnn {
  final String result;
  Dnn({this.result});

  factory Dnn.fromJson(Map<String, dynamic> json) {
    return Dnn(
      result: json['result'],
    );
  }
}