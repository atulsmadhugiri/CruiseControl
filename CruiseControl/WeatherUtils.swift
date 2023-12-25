import CoreLocation
import Foundation
import WeatherKit

@MainActor class WeatherUtils: ObservableObject {
  @Published var weather: Weather?
  func getWeather() async {
    do {
      weather = try await Task.detached(priority: .userInitiated) {
        return try await WeatherService.shared.weather(
          for: .init(latitude: 12.97740, longitude: 77.57423))
      }.value
    } catch {
      fatalError("\(error)")
    }
  }
  var symbol: String {
    weather?.currentWeather.symbolName ?? "xmark"
  }
  var temp: String {
    let temp =
      weather?.currentWeather.temperature

    let convert = temp?.formatted(
      .measurement(
        width: .abbreviated, usage: .weather,
        numberFormatStyle: .number.precision(.fractionLength(1))))
    return convert ?? "Loading Weather Data"
  }
}
