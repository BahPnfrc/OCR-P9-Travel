import Foundation
import UIKit

class WeatherZoneController {
    
    enum Position {
        case top, sub
    }
    
    let position: Position
    
    private weak var backgroundView: UIView!
    private weak var cityLabel: UILabel!
    private weak var countryLabel: UILabel!
    private weak var tempLabel: UILabel!
    private weak var weatherLabel: UILabel!
    private weak var weatherImageView: UIImageView!
    
    private enum Label: String {
        case city = "Ville"
        case temp = "Température : "
        case weather = "Temps : "
    }
    
    init(position: Position, background: UIView, city: UILabel, country: UILabel, temp: UILabel, weather: UILabel, image: UIImageView) {
        self.position = position
        self.backgroundView = background
        self.cityLabel = city
        self.countryLabel = country
        self.tempLabel = temp
        self.weatherLabel = weather
        self.weatherImageView = image
        
        hideCityTempWeather()
        hideImage()
    }
    
    func setCity(with city: String) {
        cityLabel.text = city
    }
    
    func setCountry(with country: String) {
        countryLabel.text = country
    }
    
    func setTemp(with temp: String) {
        tempLabel.text = Label.temp.rawValue + temp + " °C"
    }
    
    func setWeather(with weather: String) {
        weatherLabel.text = weather.count > 15 ?
        weather.capitalizingFirstLetter():
        Label.weather.rawValue + weather
    }
    
    func hideCityTempWeather() {
        cityLabel.text = Label.city.rawValue
        countryLabel.text = nil
        tempLabel.text = Label.temp.rawValue
        weatherLabel.text = Label.weather.rawValue
    }
    
    func setImage(with image: UIImage) {
        weatherImageView.isHidden = false
        weatherImageView.image = image
    }
    
    func hideImage() {
        weatherImageView.isHidden = true
        weatherImageView.image = nil
    }

}
