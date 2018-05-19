import 'dart:convert';
import 'package:http/http.dart' as http;

void loadData(String url) async { 
  final response = await http.get(url);
  print('\nGET from: ' + url); 
  var jsonResponse = JSON.decode(response.body);
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  print(encoder.convert(jsonResponse) + '\n');
}

void main() {
  loadData('https://stardewvalleywiki.com/mediawiki/api.php?action=query&format=json&list=allpages');
  loadData('https://stardewvalleywiki.com/mediawiki/api.php?action=opensearch&search=cow&limit=10&format=json');
}

