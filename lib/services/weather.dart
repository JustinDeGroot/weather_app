import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/networking.dart';

const apiKey = 'c03b5fc6ca7f31d703902030fbdda737';
const openWeatherMapURL = 'https://api.openweathermap.org';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    //http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}

    NetworkHelper latLonNetworkHelper = NetworkHelper(
        '$openWeatherMapURL/geo/1.0/direct?q=$cityName&limit=5&appid=$apiKey');
    var latLongData = await latLonNetworkHelper.getData();

    double lat = latLongData[0]['lat'];
    double lon = latLongData[0]['lon'];

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  Future<dynamic> getCurrentLocationWeather() async {
    Location location = Location();
    await location.determinePosition();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
