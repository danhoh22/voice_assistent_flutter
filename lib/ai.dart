import 'dart:convert';
import 'weather_service.dart';
import 'weather_forecast.dart';
import 'package:intl/intl.dart';

class AI {
  final RegExp weatherPattern = RegExp(
    r'погода в городе (\p{L}+)',
    caseSensitive: false,
    unicode: true,
  );

  Future<List<WeatherForecast>> _fetchWeatherData(String city) async {
    final response = await WeatherService().getData(city);
    final data = json.decode(response);

    Map<String, WeatherForecast> dailyForecasts = {};

    for (var item in data['list']) {
      final dateTime = DateTime.parse(item['dt_txt']);
      final date = DateFormat('yyyy-MM-dd').format(dateTime); // Группировка по дате
      final temp = item['main']['temp'].toString();
      final cloudiness = item['weather'][0]['description'];

      // Если еще нет записи на этот день, добавляем
      if (!dailyForecasts.containsKey(date)) {
        dailyForecasts[date] = WeatherForecast(date, temp, cloudiness);
      }
    }

    return dailyForecasts.values.toList();
  }

  Future<String> getAnswer(String question) async {
    final match = weatherPattern.firstMatch(question);
    if (match != null) {
      final city = match.group(1);
      if (city != null) {
        final forecasts = await _fetchWeatherData(city);
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Прогноз погоды в городе $city на несколько дней:');
        for (var forecast in forecasts) {
          buffer.writeln(forecast.toString());
        }
        return buffer.toString();
      }
    }
    return 'Извините, я не понял вопрос.';
  }
}
