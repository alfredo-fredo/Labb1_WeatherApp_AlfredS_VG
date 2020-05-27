//
//  ViewController.swift
//  Labb1Swift
//
//  Created by Alfred on 2020-02-18.
//  Copyright © 2020 Alfred. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityWind: UILabel!
    @IBOutlet weak var recClothing: UILabel!
    
    @IBOutlet weak var cityWeatherIcon: UIImageView!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var weatherView: UIView!
    
    var animator: UIDynamicAnimator!
    
    var startPos: CGAffineTransform!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        citiesTableView.reloadData()
    
        startPos = self.weatherView.transform
        
        self.citiesTableView.alpha = 0
        
        self.weatherView.transform = CGAffineTransform(translationX: 0, y: -400)
        
        UIView.animate(withDuration: 1.2, animations: {
            self.weatherView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.citiesTableView.alpha = 100
        })
    }

    @objc func dropDynamic(){
        //UI Dynamics
        var gravity: UIDynamicBehavior!
        gravity = UIGravityBehavior(items: [weatherView])
        
        animator.addBehavior(gravity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.weatherView {
                self.dropDynamic()
                print("touched weatherView")
            }
        }
    }

    func changeWeather(wData: WeatherData){
        //Call if successful api request fetched new data
        
        print("Data fetched..")
        
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 1, animations: {
            self.weatherView.transform = CGAffineTransform(translationX: 400, y: 0)
            
        }, completion: { _ in
        
            self.weatherView.frame.origin.y = self.startPos.ty + 40
            
        self.cityName.text = wData.name
        
        var celsius = wData.main.temp - 273.15
        celsius = Double(round(10*celsius)/10)
        self.cityTemp.text = "\(celsius)" + "℃"
            
        self.cityWind.text = "\(wData.wind.speed)" + " m/s"
            
            self.recClothing.text = self.recommendedClothing(celsius)
            
            let iconUrl = URL(string: "https://openweathermap.org/img/wn/" + wData.weather[0].icon + "@2x.png")!
            
            self.cityWeatherIcon.load(url: iconUrl)
            
            self.weatherView.transform = CGAffineTransform(translationX: -400, y: 0)
            
            UIView.animate(withDuration: 1.2, animations: {
                self.weatherView.transform = CGAffineTransform(translationX: 0, y: 0)
                
            })
        })
            
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.searchTextField.text ?? "Error"
        
        fetchWeather(cityName: searchText, completionHandler: changeWeather)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let cities = getCities()
        
        cell.textLabel!.text = cities[indexPath.row]
        
        print("cell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        let cell = tableView.cellForRow(at: indexPath)
        let rowCity = cell?.textLabel?.text
        
        fetchWeather(cityName: rowCity!, completionHandler: changeWeather)
    }
    
    func recommendedClothing(_ temp:Double) -> String{
        var clothing: String!
        
        if(temp < 0){
            clothing = "Tjocktröja, jacka och underställ behövs."
        }else if(temp < 10){
            clothing = "Tjocka kläder och en jacka behövs!"
        }else if(temp < 15){
            clothing = "En jacka och ett par jeans funkar!"
        }else if(temp < 20){
            clothing = "En T-shirt och en lätt jacka rekommenderas."
        }else if(temp < 30){
            clothing = "Varmt är det! En skön tröja borde räcka."
        }else if(temp < 40){
            clothing = "Otrolig värme, glöm inte att dricka vatten!"
        }
        
        return clothing
    }
}

extension UIImageView {
    func load(url: URL) {
        print("load url to image")
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                print("data from url")
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        print("Image loaded..")
                    }
                }
            }
        }
    }
}

