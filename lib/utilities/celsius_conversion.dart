String celsiusConversion({
  required double temp,
}) {
  return (temp - 273.15).toStringAsFixed(1);
}
