import Foundation

struct WeatherJson: Codable {
    let name: String
    let cod: Int
    
    // MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int?
        let main, weatherDescription, icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let country: String
        let sunrise, sunset: Int
    }
    
    let weather: [Weather]
    let main: Main
    let sys: Sys

}
