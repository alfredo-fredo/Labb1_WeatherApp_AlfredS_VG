//
//  ApiRequest.swift
//  Labb1Swift
//
//  Created by Alfred on 2020-02-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

import Foundation
import UIKit

func fetchWeatherIcon(icon:String, completionHandler: @escaping (UIImage) -> Void){
    let baseUrl = "https://openweathermap.org/img/wn/"
    let iconUrl = "@2x.png"
    
    let wholeUrl = baseUrl + icon + iconUrl
    
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
      print(data)
      //print("Weather name: \(String(describing: Weather.name))")
        
      do {
          let data = data
    
          let image = UIImage(data: data as! Data)
        
          DispatchQueue.main.async {
            print("Success! Icon loaded.")
        
            let failImage = UIImage(systemName: "globe")
            completionHandler(image ?? failImage!)
          }
          
      } catch {
          print("Failed! Icon not loaded.")
          print(error)
      }
      
      
    })
    task.resume()
    
}


func fetchWeather(cityName:String, completionHandler: @escaping (WeatherData) -> Void) {
    
    var city = cityName.lowercased();
    
    if(city.contains("ä") || city.contains("å") || city.contains("ö")){
        
        city = city.replacingOccurrences(of: "ä", with: "a")
        city = city.replacingOccurrences(of: "å", with: "a")
        city = city.replacingOccurrences(of: "ö", with: "oe")
        print(city)
    }
    
    let source = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKey = "&appid=a6b7ef09581be1f3dee7e715dc64db03"
    
    let wholeUrl = source + city + apiKey
    
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
    print(data)
    //print("Weather name: \(String(describing: Weather.name))")
        
    do {
        let data = data
        let weatherData: WeatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
        print("City name: \(String(describing: weatherData.name))")
            print("Success! JSON decoded")
        
        DispatchQueue.main.async {
            completionHandler(weatherData)
        }
        
    } catch {
        print("Failed! JSON not decoded")
        print(error)
    }
    
    
  })
  task.resume()
}
