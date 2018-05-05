import 'dart:convert';
import 'package:http/http.dart' as http;

void loadData(String url) async {
  print('GET from: ' + 'https://en.wikipedia.org/w/api.php?action=query&format=json&list=allpages');
  final response = await http.get(url);
  print(response.body); 
}

void main() {
  loadData('https://en.wikipedia.org/w/api.php?action=query&format=json&list=allpages');
}

