import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvData {
  String backendApi() {
    return dotenv.env['BACKEND_API_URL']!;
  }

  String weatherApiKey() {
    return dotenv.env['WEATHER_API_KEY']!;
  }
}
