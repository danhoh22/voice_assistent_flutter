class WeatherForecast {
  late String date;
  late String temperature;
  late String cloudiness;

  WeatherForecast(this.date, this.temperature, this.cloudiness);

  @override
  String toString() {
    return 'Дата: $date, Температура: $temperature°C, Облачность: $cloudiness';
  }
}
