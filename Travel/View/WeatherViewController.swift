//
//  WeatherViewController.swift
//  Travel
//
//  Created by Genapi on 09/11/2021.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func Taped(_ sender: Any) {
        
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespaces), city.count > 0 else {
            return
        }
        
        WeatherCall.shared.getWeather(forCity: city) { success, weatherModel in
            
            guard success, let weatherModel = weatherModel else {
            
                  let alert = UIAlertController(title: "Erreur", message: "Erreur lors d'un appel réseau", preferredStyle: .alert)
                  let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                  alert.addAction(action)
                  self.present(alert, animated: true, completion: nil)
                    return
                        
            }
            
            self.cityLabel.text = "Ville : " + weatherModel.name
            self.tempLabel.text = "Température : " + weatherModel.main.temp.toString() + "°C"
            self.weatherLabel.text = "Temps : " + weatherModel.weather[0].weatherDescription
            
            let icon = weatherModel.weather[0].icon
            WeatherCall.shared.getIcon(forCode: icon) { success, image in
                if success, let image = image {
                    self.weatherImageView.image = image
                }
                
            }
           
            
        }
        
    }
    
    
}
