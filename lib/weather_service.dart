import 'package:http/http.dart' as http;

class WeatherService {
  final String _url = 'https://api.openweathermap.org';
  final String _path = '/data/2.5/forecast';
  final String _params = '?appid=ae037f8d311d56ab041f752ade967f26&units=metric&lang=ru&q=';

  Future<String> getData(String city) async {
    final response = await http.get(Uri.parse('$_url$_path$_params$city'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
