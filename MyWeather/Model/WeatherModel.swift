//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Darrell Bowdon on 6/11/21.
//

import Foundation

// Current Weather Data
struct WeatherData: Codable {
    let dt: Int
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// Daily Weather Data

struct DailyWeather: Codable {
    let daily: [Daily]
    let hourly: [HourlyWeather]
    let current: Current
}

struct LocationData: Codable {
    let name: String
}

struct Current: Codable {
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let temp: Temp
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

//HourlyWeather
struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double
}
