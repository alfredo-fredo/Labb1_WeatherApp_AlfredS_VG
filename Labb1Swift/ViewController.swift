//
//  ViewController.swift
//  Labb1Swift
//
//  Created by Alfred on 2020-02-18.
//  Copyright © 2020 Alfred. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityWeatherIcon: UIImageView!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var weatherView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       /* var data = wData(name: "eyo", temp: "baba", weather: "hej") */
        var startPos = self.weatherView.transform
        self.citiesTableView.alpha = 0
        
        self.weatherView.transform = CGAffineTransform(translationX: 0, y: -400)
        
        UIView.animate(withDuration: 1.2, animations: {
            self.weatherView.transform = CGAffineTransform(translationX: 0, y: startPos.ty)
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.citiesTableView.alpha = 100
        })
        
    }


    func changeWeather(wData: WeatherData){
        //Call if successful api request fetched new data
        
        UIView.animate(withDuration: 1, animations: {
            self.weatherView.transform = CGAffineTransform(translationX: 400, y: 0)
            
        }, completion: { _ in
            
            self.cityName.text = "Stockholm"
            self.cityTemp.text = "17 *C"
            
            self.weatherView.transform = CGAffineTransform(translationX: -400, y: 0)
            
            UIView.animate(withDuration: 1.2, animations: {
                self.weatherView.transform = CGAffineTransform(translationX: 0, y: 0)
                
            })
        })
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchText = searchBar.searchTextField.text ?? "Error"
        
        fetchWeather(cityName: searchText, completionHandler: changeWeather)
        
    }
    
}

