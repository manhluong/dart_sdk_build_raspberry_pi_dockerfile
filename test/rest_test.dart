import 'dart:convert';
import 'package:http/http.dart' as http;

void loadData(String url) async {
  print('GET from: ' + url);
  final response = await http.get(url);
  var jsonResponse = JSON.decode(response.body);
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  print(encoder.convert(jsonResponse));
}

void main() {
  loadData('https://stardewvalleywiki.com/mediawiki/api.php?action=query&format=json&list=allpages');
}

