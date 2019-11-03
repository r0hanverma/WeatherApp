//
//  ViewController.swift
//  WeatherApp2UsingAlam
//
//  Created by rohan verma on 02/11/19.
//  Copyright © 2019 rohan verma. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var ConditionImageView: UIImageView!
    @IBOutlet weak var ConditionLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var BackgroundView: UIView!
    
    let GradientLayer = CAGradientLayer()
    let ApiKey = "2a5ca26cf5bc00db4573291b8c5d193e"
    var lat = 11.11
    var lon = 11.11
    var ActivityIndicator : NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundView.layer.addSublayer(GradientLayer)
        
        let indicatorSize : CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width - indicatorSize)/2, y: (view.frame.height - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        ActivityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .circleStrokeSpin, color: UIColor.white, padding: 20.0)
        ActivityIndicator.backgroundColor = UIColor.black
        view.addSubview(ActivityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        ActivityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    //optional
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
        }
    //optional ends
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
    lat = location.coordinate.latitude
    lon = location.coordinate.longitude
    Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(ApiKey)&units=metric").responseJSON {
        response in
        self.ActivityIndicator.stopAnimating()
        if let responseStr = response.result.value {
            let jsonResponse = JSON(responseStr)
            let jsonWeather = jsonResponse["weather"].array![0]
            let jsonTemp = jsonResponse["main"]
            let iconName = jsonWeather["icon"].stringValue
            self.LocationLabel.text = jsonResponse["name"].stringValue
            self.ConditionImageView.image = UIImage(named: iconName)
            self.ConditionLabel.text = jsonWeather["main"].stringValue
            self.TemperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            self.DayLabel.text = dateFormatter.string(from: date)
            let suffix = iconName.suffix(1)
            if (suffix == "d"){
                self.setBlueGradientBackground()
            }
            if (suffix == "n"){
                self.setGreyGradientBackground()
                       }
        }
        
    }
    self.locationManager.stopUpdatingLocation()
    }
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
    }
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        GradientLayer.frame = view.bounds
        GradientLayer.colors = [topColor,bottomColor]
    }

    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
                  let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
                  GradientLayer.frame = view.bounds
                  GradientLayer.colors = [topColor,bottomColor]
       }
}

