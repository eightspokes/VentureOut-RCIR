//
//  WeatherManager.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/23/23.
//

import Foundation
import CoreLocation

class WeatherManager{
    
    
    static let location = CLLocation(
        latitude: .init(floatLiteral: 43.094200),
        longitude: .init(floatLiteral: -77.681800)
    
    )
    static let apiKey = "34976a5124c35609804a1c448800c3d7"
    
    
    
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse{
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherManager.apiKey)&units=metric"
        guard let url = URL(string: urlString) else {fatalError("Missing Url")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fatching ")}
        
        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return decodedData
        
    }
}


struct WeatherResponse: Codable {
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
