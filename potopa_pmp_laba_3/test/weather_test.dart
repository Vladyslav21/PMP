import 'package:potopa_pmp_laba_3/weather.dart';
import 'package:test/test.dart';

void main() {
  test('Conversion from JSON.', () {
    final w = WeatherInfo.fromDb({
      "id": "Khmelnytskyy",
      "temperature": "-5.3",
      "wind": "19.3"
    });

    expect(w.id, "Khmelnytskyy");
    expect(w.temperature, -5.3);
    expect(w.wind, 19.3);
  });

  test('Conversion to JSON.', () {
    final w = WeatherInfo(id: "Barcelona", temperature: 11.8, wind: 3.4);

    final json = w.toMap();

    expect(json, {
      "id": "Barcelona",
      "temperature": 11.8,
      "wind": 3.4
    });
  });
}
