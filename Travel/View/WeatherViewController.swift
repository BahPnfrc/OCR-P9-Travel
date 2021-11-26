import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var defView: UIView!
    @IBOutlet weak var defCityLabel: UILabel!
    @IBOutlet weak var defTempLabel: UILabel!
    @IBOutlet weak var defWeatherLabel: UILabel!
    @IBOutlet weak var defWeatherImageView: UIImageView!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userTempLabel: UILabel!
    @IBOutlet weak var userWeatherLabel: UILabel!
    @IBOutlet weak var userWeatherImageView: UIImageView!
    
    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlTextField: UITextField!
    @IBOutlet weak var ctrlButton: UIButton!
    
    let defCity = "New York"
    var defUnit: Units = .metric
    var defZone: WeatherZoneController!
    var userZone: WeatherZoneController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defZone = WeatherZoneController(background: defView, city: defCityLabel, temp: defTempLabel, weather: defWeatherLabel, image: defWeatherImageView)
        userZone = WeatherZoneController(background: userView, city: userCityLabel, temp: userTempLabel, weather: userWeatherLabel, image: userWeatherImageView)
        
        getWeather(forCity: defCity, withUnit: defUnit, forZone: defZone)
        
        paint()
    }
    
    private func paint() {
        for container in [defView, userView, ctrlView ]{
            container?.backgroundColor = Painting.defViewColor
            container?.layer.cornerRadius = Painting.defRadius
        }
        ctrlButton.backgroundColor = Painting.lightBlue
        ctrlButton.layer.cornerRadius = Painting.defRadius
        
        defCityLabel.textColor = Painting.cream
        userCityLabel.textColor = Painting.cream
        
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let city = ctrlTextField.text?.trimmingCharacters(in: .whitespaces), city.count > 0 else {
            ctrlTextField.becomeFirstResponder()
            ShowError(with: "Le champ 'ville' est invalide")
            return
        }
        getWeather(forCity: city, withUnit: defUnit, forZone: userZone)
    }

    private func ShowError(with message: String) {
        let alert = UIAlertController(title: "Erreur :", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        return
    }
    
    private func getWeather(forCity: String, withUnit: Units, forZone zone: WeatherZoneController) {
        WeatherService.shared.getWeather(forCity: forCity, withUnit: withUnit) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let weatherModel):
                
                DispatchQueue.main.async {
                    let data: (city: String, temp: String, weather: String) = (weatherModel.name, weatherModel.main.temp.toString(), weatherModel.weather[0].weatherDescription)
        
                    zone.setCity(with: data.city)
                    zone.setTemp(with: data.temp)
                    zone.setWeather(with: data.weather)
                }
                    
                guard !weatherModel.weather.isEmpty else {
                    return
                }
                
                let icon = weatherModel.weather[0].icon
                WeatherService.shared.getIcon(forCode: icon) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            zone.setImage(with: image)
                        case .failure(let error):
                            print(error.localizedDescription)
                            zone.hideImage()
                        }
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.ShowError(with: error.localizedDescription)
            }
        }
    }
    
}
