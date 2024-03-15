//
//  ViewController.swift
//  AppClima
//
//  Created by Адиль on 13/3/24.
//
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    private var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = .weather
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .weather
        label.highlightedTextColor = .weather
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var temperatureLabelString: UILabel = {
        let labelStr = UILabel()
        labelStr.translatesAutoresizingMaskIntoConstraints = false
        return labelStr
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .weather
        label.highlightedTextColor = .weather
        label.font = .systemFont(ofSize: 50, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.font = .systemFont(ofSize: 30)
        textField.textAlignment = .right
        textField.textColor = .weather
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var searchButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        setupBackgroundImage()
        setupSearchButton()
        setupLocationButton()
        setupSearchTextField()
        setupConditionImage()
        setupTemperatureLabel()
        setupCityLabel()
    }
    
    private func setupLocationButton() {
        view.addSubview(locationButton)
        locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        locationButton.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        
        let leftButton = UIBarButtonItem()
        leftButton.customView = locationButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    private func setupSearchButton() {
        view.addSubview(searchButton)
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchButton.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = searchButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchTextField)
        searchTextField.centerXAnchor.constraint(equalTo: navBar!.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 8
        searchTextField.layer.borderColor = .init(CGColor(gray: 3, alpha: 1))
    }
    
    private func setupConditionImage() {
        view.addSubview(conditionImageView)
        conditionImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        conditionImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        conditionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        conditionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 500).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor,constant: 0).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    
    private func setupCityLabel() {
        view.addSubview(cityLabel)
        cityLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 500).isActive = true
        cityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor,constant: 0).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
    }
    
    private func setupBackgroundImage() {
        if traitCollection.userInterfaceStyle == .dark {
            let img = UIImage(named: "dark_background")
            view.layer.contents = img?.cgImage
        } else {
            let img = UIImage(named: "light_background")
            view.layer.contents = img?.cgImage
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @objc
    private func searchPressed() {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString + "°C"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print("#### error: \(error)")
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    @objc
    private func locationPressed() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
