import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstant {
  String backendApi() {
    return dotenv.env['BACKEND_API_URL']!;
  }

  String weatherApiKey() {
    return dotenv.env['WEATHER_API_KEY']!;
  }

  String imageFrontUrl() {
    return dotenv.env['SIRV_URL']!;
  }
}
