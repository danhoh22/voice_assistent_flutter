class Weather {
  late String temperature;
  late String cloudiness;

  Weather(this.temperature, this.cloudiness);

  @override
  String toString() {
    return 'Temperature: $temperature°C, Cloudiness: $cloudiness';
  }
}
