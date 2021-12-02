import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var defView: UIView!
    @IBOutlet weak var defCityLabel: UILabel!
    @IBOutlet weak var defTempLabel: UILabel!
    @IBOutlet weak var defWeatherLabel: UILabel!
    @IBOutlet weak var defWeatherImageView: UIImageView!
    @IBOutlet weak var defCountryLabel: UILabel!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userTempLabel: UILabel!
    @IBOutlet weak var userWeatherLabel: UILabel!
    @IBOutlet weak var userWeatherImageView: UIImageView!
    @IBOutlet weak var userCountryLabel: UILabel!
    
    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlTextField: UITextField!
    @IBOutlet weak var ctrlButton: UIButton!
    @IBOutlet weak var ctrlClearButton: UIButton!
    
    @IBOutlet weak var clearTextImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var useNativeIcon = true
    var isAtInitialPosition = false
    
    let defCity = "New York"
    var defUnit: Units = .metric
    var defZone: WeatherZoneController!
    var userZone: WeatherZoneController!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defZone = WeatherZoneController(
            position: .top,
            background: defView,
            city: defCityLabel,
            country: defCountryLabel,
            temp: defTempLabel,
            weather: defWeatherLabel,
            image: defWeatherImageView)
        userZone = WeatherZoneController(
            position: .sub,
            background: userView,
            city: userCityLabel,
            country: userCountryLabel,
            temp: userTempLabel,
            weather: userWeatherLabel,
            image: userWeatherImageView)
        
        displayWeather(forCity: defCity, withUnit: defUnit, forZone: defZone)
        initialPosition()
        paint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctrlTextField.becomeFirstResponder()
    }
    
    private func paint() {
        for container in [defView, userView, ctrlView ]{
            container?.backgroundColor = Painting.defViewColor
            container?.layer.cornerRadius = Painting.defRadius
        }
        ctrlButton.layer.cornerRadius = Painting.defRadius
        activityView.hidesWhenStopped = true
    }
    
    private func initialPosition() {
        guard let userViewPosition = userView.superview?.convert(userView.frame.origin, to: nil),
              let ctrlViewPosition = ctrlView.superview?.convert(ctrlView.frame.origin, to: nil)
        else { return }
        
        self.userView.isHidden = true
        self.isAtInitialPosition = true
        
        let yMotion = abs(userViewPosition.y - ctrlViewPosition.y)
        UIView.animate(withDuration: 0.0, animations: {
            self.ctrlView.transform = CGAffineTransform.init(translationX: 0, y: 0 - yMotion)
            self.ctrlClearButton.transform = CGAffineTransform.init(translationX: 0, y: 0 - yMotion)
            self.clearTextImageView.transform = CGAffineTransform.init(translationX: 0, y: 0 - yMotion)
        })
    }
    
    private func restorePosition() {
        guard isAtInitialPosition else { return }
        UIView.animate(withDuration: 0.5, animations: {
            self.ctrlView.transform = CGAffineTransform.identity
            self.ctrlClearButton.transform = CGAffineTransform.identity
            self.clearTextImageView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.userView.isHidden = false
        })
    }
    
    // MARK: - Actions
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let city = ctrlTextField.text?.trimmingCharacters(in: .whitespaces),
              city.count > 0 else { return }
        displayWeather(forCity: city, withUnit: defUnit, forZone: userZone)
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        Shared.clearText(of: ctrlTextField, rotating: clearTextImageView)
    }
    
    // MARK: - Tools
    
    // Empty
    
    // MARK: - Functions
    
    // MARK: Weather function
    
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
                        self.restorePosition()
                    }
                    
                    let data: (city: String, country: String, temp: String, weather: String) = (weatherModel.name, weatherModel.sys.country, weatherModel.main.temp.toString(1), weatherModel.weather[0].weatherDescription)
                    
                    zone.setCity(with: data.city)
                    zone.setCountry(with: data.country)
                    zone.setTemp(with: data.temp)
                    zone.setWeather(with: data.weather)
                    
                    self.displayImage(fromModel: weatherModel, toZone: zone)
                }
            }
        }
    }
    
    // MARK: Image functions
    
    private func displayImage(fromModel weatherModel: WeatherJson, toZone zone: WeatherZoneController) {
        
        guard !weatherModel.weather.isEmpty else { return }
        let code = weatherModel.weather[0].icon
        
        switch self.useNativeIcon {
        case true:
            let codeRawValue = "icon\(code.prefix(2))"
            let iconCode = IconCode(rawValue: codeRawValue)
            if let image = iconCode?.getNativeImage {
                zone.setImage(with: image)
            } else { fallthrough }
        default:
            self.getDistantImage(forCode: code, forZone: zone)
        }
    }
    
    private func getDistantImage(forCode code: String, forZone zone: WeatherZoneController) {
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

extension WeatherViewController {
    
    enum IconCode: String {
        case icon01, icon02, icon03, icon04
        case icon09, icon10, icon11
        case icon13
        case icon50
        
        var systemImage: String {
            switch self {
            case .icon01: return "sun.max" // clear sky
            case .icon02: return "cloud.sun" // few clouds
            case .icon03: return "cloud.sun" // clouds
            case .icon04: return "smoke" // broken clouds
            case .icon09: return "cloud.rain" // shower rain
            case .icon10: return "cloud.sun.rain" // rain
            case .icon11: return "cloud.bolt" // thunderstorm
            case .icon13: return "cloud.snow" //snow
            case .icon50: return "cloud.fog" // mist
            }
        }
        
        var getNativeImage: UIImage? {
            let config = UIImage.SymbolConfiguration(paletteColors: [.black, .black, .black])
            let image = UIImage(systemName: self.systemImage)
            return image?.applyingSymbolConfiguration(config)
        }
    }
    
}
