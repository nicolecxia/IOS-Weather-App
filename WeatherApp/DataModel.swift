//
//  DataModel.swift
//  WeatherApp
//
//  Created by Nicole Xia on 2024-07-13.
//

import Foundation


struct WeatherResponse: Decodable
{
    let location: Location
    let current: Weather
    
}

struct Location: Decodable
{
    let name: String
    var region: String
    var country: String
}

struct Weather: Decodable
{
    let temp_c: Float
    var temp_f: Float
    let condition: WeatherCondition
}


struct WeatherCondition: Decodable
{
    let text: String
    let code: Int
}


struct citiesWeatherInfo {
    var cityAndRegion: String
    var cityName: String
    var region: String
    var temp_c: Float
    var temp_f: Float
    var text: String
    var iconName: String
    var tempFormat:String
}
