//
//  ApiRequest.swift
//  Labb1Swift
//
//  Created by Alfred on 2020-02-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

import Foundation
import UIKit

//completionHandler: @escaping ([Film]) -> Void
func fetchWeather(cityName:String, completionHandler: @escaping (WeatherData) -> Void) {
    
    let source = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKey = "&appid=a6b7ef09581be1f3dee7e715dc64db03"
    
    let wholeUrl = source + cityName + apiKey
    
    let url = URL(string: wholeUrl)!

  let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
    if let error = error {
      print("Error with fetching weather data: \(error)")
      return
    }
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      print("Error with the response, unexpected status code: \(response)")
      return
    }

    print("Success!")
    
    if let data = data,
        let weatherData = try?
            JSONDecoder().decode(WeatherData.self, from: data) {
        print("Success! JSON decoded")
        completionHandler(weatherData)
    }
    print("Failed! JSON not decoded")
  })
  task.resume()
}
