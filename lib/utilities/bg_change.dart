dynamic bgChange({required bool isClick, required String currentIcon}) {
  if (isClick) {
    String weatherIcon = currentIcon;

    if (weatherIcon.contains('01')) {
      return 'sky.jpg';
    } else if (weatherIcon.contains('02') ||
        weatherIcon.contains('03') ||
        weatherIcon.contains('04')) {
      return 'clouds.jpg';
    } else if (weatherIcon.contains('09') || weatherIcon.contains('10')) {
      return 'rain.jpg';
    } else if (weatherIcon.contains('11')) {
      return 'thunderstorm.jpg';
    } else if (weatherIcon.contains('13')) {
      return 'snow.jpg';
    } else if (weatherIcon.contains('50')) {
      return 'mist.jpg';
    }
  }
}
