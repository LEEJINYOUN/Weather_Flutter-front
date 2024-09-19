String celsiusConversion({
  required double temp,
}) {
  double CELSIUS = 273.15;
  return "${(temp - CELSIUS).toStringAsFixed(1)}\u00b0 C";
}
