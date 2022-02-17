//
//  WeatherAPI.swift
//  Final Project
//
//  Created by Andria Kilasonia on 14.02.22.
//
import Foundation

class WeatherAPI {
    
    private static let API_KEY = "a8cbe4a8b4946a8ffae05d61cb34549c"
    private static let directions = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func getToday(
        latitude: Double?,
        longitude: Double?,
        completion: @escaping (TodayData?) -> Void
    ) {
        connectToApi(
            latitude: latitude,
            longitude: longitude,
            urlPathEnd: "/weather",
            dataModifier: getTodayData,
            completion: completion
        )
    }

    static func getForecast(
        latitude: Double?,
        longitude: Double?,
        completion: @escaping ([ForecastSection]?) -> Void
    ) {
        connectToApi(
            latitude: latitude,
            longitude: longitude,
            urlPathEnd: "/forecast",
            dataModifier: getForecastSections,
            completion: completion
        )
    }
    
    private static func connectToApi<DataType, CastType: Codable>(
        latitude: Double?,
        longitude: Double?,
        urlPathEnd: String,
        dataModifier: @escaping (CastType) -> DataType,
        completion: @escaping (DataType?) -> Void
    ) {
        if let latitude = latitude, let longitude = longitude {
            var urlComponent: URLComponents = getCommonUrl(latitude: latitude, longitude: longitude)
            urlComponent.path += urlPathEnd
            
            let task = session.dataTask(with: urlComponent.url!, completionHandler: { data, resp, error in
                if let response = resp as? HTTPURLResponse {
                    if response.statusCode == 200, let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(CastType.self, from: data)
                            completion(dataModifier(result))
                            
                            return
                        } catch {}
                    }
                }
                completion(nil)
            })
            
            task.resume()
        } else { completion(nil) }
    }
    
    private static func getCommonUrl(latitude: Double, longitude: Double) -> URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5"
        urlComponent.queryItems = [
            URLQueryItem(name: "appid", value: API_KEY),
            URLQueryItem(name: "lat", value: latitude.description),
            URLQueryItem(name: "lon", value: longitude.description),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        return urlComponent
    }
    
    private static func getTodayData(with forecast: Today) -> TodayData {
        return TodayData(
            imagePath: getIconUrl(from: forecast.weather[0].icon),
            region: "\(forecast.name), \(forecast.sys.country)",
            temperature: Int(forecast.main.temp.rounded()),
            weather: forecast.weather[0].main,
            cloudPercentage: forecast.clouds.all,
            humidityPercentage: forecast.main.humidity,
            pressure: Double(forecast.main.pressure),
            windSpeed: forecast.wind.speed,
            windDirection: getDirection(with: forecast.wind.deg)
        )
    }
    
    private static func getForecastCellModel(with forecast: Forecast) -> ForecastCellModel {
        return ForecastCellModel(
            imagePath: getIconUrl(from: forecast.weather[0].icon),
            time: forecast.hour,
            weather: forecast.weather[0].description,
            temperature: Int(forecast.main.temp.rounded())
        )
    }
    
    private static func getForecastSections(with forecastResponse: ForecastResponse) -> [ForecastSection] {
        let forecasts = forecastResponse.list
        var sections = [ForecastSection(weekday: forecasts[0].weekDay, forecastCells: [ForecastCellModel]())]
        
        for forecast in forecasts {
            if forecast.weekDay != sections.last!.weekday {
                sections.append(
                    ForecastSection(weekday: forecast.weekDay, forecastCells: [ForecastCellModel]())
                )
            }
            
            sections[sections.count - 1].forecastCells.append(getForecastCellModel(with: forecast))
        }
        
        return sections
    }
    
    private static func getDirection(with degrees: Int) -> String {
        return directions[((degrees + 22) % 360) / 45]
    }
    
    private static func getIconUrl(from iconId: String) -> String {
        return "https://openweathermap.org/img/wn/\(iconId)@2x.png"
    }
    
}

struct Today: Codable {
    let main: Temperature
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let name: String
    let sys: System
}

struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let hour: String
    let weekDay: String
    let main: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case hour = "dt"
        case weekDay
        case main
        case weather
    }

    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try containter.decode(Temperature.self, forKey: .main)
        self.weather = try containter.decode([Weather].self, forKey: .weather)
        
        // hour/weekday
        let dt = try containter.decode(Int.self, forKey: .hour)
        let date = Date(timeIntervalSince1970: TimeInterval(dt))

        // hour
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        self.hour = timeFormatter.string(from: date)

        // weekday
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.dateFormat = "EEEE"
        self.weekDay = weekDayFormatter.string(from: date).uppercased()
    }
    
}

struct Temperature: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct System: Codable {
    let country: String
}
