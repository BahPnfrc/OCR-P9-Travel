import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    
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
    
    @IBOutlet weak var withCityImageView: UIImageView!
    @IBOutlet weak var withoutCityImageView: UIImageView!
    @IBOutlet weak var clearTextImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let defCity = "New York"
    var defUnit: Units = .metric
    var defZone: WeatherZoneController!
    var userZone: WeatherZoneController!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defZone = WeatherZoneController(position: .top, background: defView, city: defCityLabel, temp: defTempLabel, weather: defWeatherLabel, image: defWeatherImageView)
        userZone = WeatherZoneController(position: .sub, background: userView, city: userCityLabel, temp: userTempLabel, weather: userWeatherLabel, image: userWeatherImageView)
        
        displayWeather(forCity: defCity, withUnit: defUnit, forZone: defZone)
        
        paint()
    }
    
    private func paint() {
        withoutCityImageView.isHidden = false
        withCityImageView.isHidden = true
        for container in [defView, userView, ctrlView ]{
            container?.backgroundColor = Painting.defViewColor
            container?.layer.cornerRadius = Painting.defRadius
        }
        ctrlButton.layer.cornerRadius = Painting.defRadius
        activityView.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let city = ctrlTextField.text?.trimmingCharacters(in: .whitespaces), city.count > 0 else {
            return
        }
        displayWeather(forCity: city, withUnit: defUnit, forZone: userZone)
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        Shared.clearText(of: ctrlTextField, rotating: clearTextImageView)
    }
    
    // MARK: - Tools
    
    // Empty
    
    // MARK: - Functions
    
    private func displayWeather(forCity: String, withUnit: Units, forZone zone: WeatherZoneController) {
        
        Shared.startAnimation(of: activityView, locking: ctrlButton)
        WeatherService.shared.getWeather(forCity: forCity, withUnit: withUnit) { [weak self] result in
            
            DispatchQueue.main.async {
                Shared.stopAnimation(of: self?.activityView, unlocking: self?.ctrlButton)
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print("🔴 Weather service KO.")
                    print(error.localizedDescription)
                    Shared.ShowError(with: Shared.defaultShowErrorMessage, inView: self)
                
                case .success(let weatherModel):
                    print("🟢 Weather service OK.")
                    
                    if zone.position == .sub {
                        self.withoutCityImageView.isHidden = true
                        self.withCityImageView.isHidden = false
                    }
                    
                    let data: (city: String, temp: String, weather: String) = (weatherModel.name, weatherModel.main.temp.toString(), weatherModel.weather[0].weatherDescription)
                    
                    zone.setCity(with: data.city)
                    zone.setTemp(with: data.temp)
                    zone.setWeather(with: data.weather)
                    
                    guard !weatherModel.weather.isEmpty else {
                        return
                    }
                    
                    let code = weatherModel.weather[0].icon
                    self.displayWeatherImage(forCode: code, forZone: zone)
                }
            }
        }
    }
    
    private func displayWeatherImage(forCode code: String, forZone zone: WeatherZoneController) {
        WeatherService.shared.getIcon(forCode: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("🔴 Weather Image KO.")
                    print(error.localizedDescription)
                    zone.hideImage()
                    Shared.ShowError(with: Shared.defaultShowErrorMessage, inView: self)
                    
                case .success(let image):
                    print("🟢 Weather Image OK.")
                    zone.setImage(with: image)
                }
            }
        }
    }
    
}
