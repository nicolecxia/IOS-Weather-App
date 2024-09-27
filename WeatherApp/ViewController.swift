//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nicole Xia on 2024-07-12.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var celsiusButton: UIButton!
    @IBOutlet weak var fahrenheitButton: UIButton!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    let weatherIcons: [Int: String] = [
        1000: "sun.max.fill",
        1003: "cloud.sun.fill",
        1006: "cloud.fill",
        1009: "cloud.fill",
        1030: "cloud.fog.fill",
        1063: "cloud.drizzle.fill",
        1066: "cloud.snow.fill",
        1069: "cloud.sleet.fill",
        1072: "cloud.hail.fill",
        1087: "cloud.bolt.fill",
        1114: "wind.snow",
        1117: "wind.snow",
        1135: "cloud.fog.fill",
        1147: "cloud.fog.fill",
        1150: "cloud.drizzle.fill",
        1153: "cloud.drizzle.fill",
        1168: "cloud.hail.fill",
        1171: "cloud.hail.fill",
        1180: "cloud.drizzle.fill",
        1183: "cloud.rain.fill",
        1186: "cloud.rain.fill",
        1189: "cloud.rain.fill",
        1192: "cloud.heavyrain.fill",
        1195: "cloud.heavyrain.fill",
        1198: "cloud.hail.fill",
        1201: "cloud.hail.fill",
        1204: "cloud.sleet.fill",
        1207: "cloud.sleet.fill",
        1210: "cloud.snow.fill",
        1213: "cloud.snow.fill",
        1216: "cloud.snow.fill",
        1219: "cloud.snow.fill",
        1222: "cloud.snow.fill",
        1225: "cloud.snow.fill",
        1237: "cloud.hail.fill",
        1240: "cloud.rain.fill",
        1243: "cloud.heavyrain.fill",
        1246: "cloud.heavyrain.fill",
        1249: "cloud.sleet.fill",
        1252: "cloud.sleet.fill",
        1255: "cloud.snow.fill",
        1258: "cloud.snow.fill",
        1261: "cloud.hail.fill",
        1264: "cloud.hail.fill",
        1273: "cloud.bolt.rain.fill",
        1276: "cloud.bolt.rain.fill",
        1279: "cloud.bolt.snow.fill",
        1282: "cloud.bolt.snow.fill"
    ]

    var citiesName:[String] = []
    var citiesWeatherInfos:[citiesWeatherInfo] = []
    
    var tempFormat:String = "C"
    var Celsius:Float = 0.0
    var Fahrenheit:Float = 0.0
    var citiesAndRegion:String = ""
    
private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        
        displayImage(iconName: "cloud.sun.fill")
        fahrenheitButton.tintColor =  .systemGray
        
        searchTextField.delegate = self
        locationManager.delegate = self
        
        //get the user location
        locationManager.requestWhenInUseAuthorization()
        getLocation()
    }
    
    //hidden the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    


    @IBAction func onLocationTapped(_ sender: UIButton)
    {
        getLocation()
    }
    
    @IBAction func onSearchTapped(_ sender: UIButton)
    {
        loadWeather(search: searchTextField.text)
    }
    
    @IBAction func onCelsiusTapped(_ sender: UIButton) {
        celsiusButton.tintColor = .systemBlue
        fahrenheitButton.tintColor = .systemGray
        
        tempFormat = "C"
        temperatureLabel.text = String(Celsius)
        changeCitiesTempFormat(citiesAndRegion:citiesAndRegion, tempFormat:"C")
    }
    
    @IBAction func onFahrenheitTapped(_ sender: UIButton) {
        fahrenheitButton.tintColor = .systemBlue
        celsiusButton.tintColor = .systemGray
        
        tempFormat = "F"
        temperatureLabel.text = String(Fahrenheit)
        changeCitiesTempFormat(citiesAndRegion:citiesAndRegion, tempFormat:"F")
    }
    
    
    
    @IBAction func onCitiesTapped(_ sender: UIButton) {
        let citiesVC = self.storyboard?.instantiateViewController(withIdentifier: "CitiesViewController") as? CitiesViewController
        
        citiesVC?.cities = citiesWeatherInfos
        
        self.navigationController?.pushViewController(citiesVC ?? CitiesViewController(), animated: true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//        print(textField.text ?? "")
        
        textField.resignFirstResponder()
        loadWeather(search: searchTextField.text)
        return true
    }
    

    private func displayImage(iconName:String)
    {
        let config = UIImage.SymbolConfiguration(paletteColors: [
            UIColor.systemBlue,.systemYellow,.systemTeal
        ])

        weatherConditionImage.preferredSymbolConfiguration = config
        
        weatherConditionImage.image = UIImage(systemName: iconName)
    }
    
    private func getLocation() {
        //get the user location
        locationManager.requestWhenInUseAuthorization()
        //for request a location
        locationManager.requestLocation()
    }
    
    
    private func loadWeather(search: String?)
    {
        activityIndicator.startAnimating()
        
        guard let search = search else
        {
            return
        }
        
        
        //Step 1: Get URL
        guard let url = getURL(query: search) else {
            print("Could not get URL")
            return
        }
        
        //Step 2:Create URLSession
        let session = URLSession.shared
        
        //Step 3: Create a task for session
        let dataTask = session.dataTask(with: url) { data, response, error in
          //network call finished
            print("Network call complete")
            
            //check if have error
            guard error == nil else
            {
                print("Receive error")
                return
            }
            
            guard let data = data else
            {
                print("No data found")
                return
            }
            
            if let weatherResponse = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.locationLabel.text = weatherResponse.location.name
                    
                    if self.tempFormat == "C"{
                        self.temperatureLabel.text = String(weatherResponse.current.temp_c)
                    }else{
                        self.temperatureLabel.text = String(weatherResponse.current.temp_f)
                    }
                        
                    self.weatherLabel.text = weatherResponse.current.condition.text
                    var iconName = "cloud.sun.fill"
                    if let iconNameTemp = self.weatherIcons[weatherResponse.current.condition.code]
                    {
                        iconName = iconNameTemp
                        self.displayImage(iconName: iconName)
                    }
                    
                    self.activityIndicator.stopAnimating()
                    
                    self.addCities(cityName: weatherResponse.location.name, region: weatherResponse.location.region, temp_c: weatherResponse.current.temp_c,temp_f: weatherResponse.current.temp_f, text: weatherResponse.current.condition.text,iconName: iconName )
                }
            }
        }
        
        //Step 4: Start the task
        dataTask.resume()
    }
    
    private func getURL(query: String) -> URL?{
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "b2b9ccd6e17348fe8a1161843241207"
        
        
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(apiKey)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        print(url)
        
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponse?{
        //decode the data
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
        }catch{
            print("Error decodeing")
        }
        
        return weather
    }
    
    private func addCities(cityName:String,region:String, temp_c: Float,temp_f: Float, text:String,iconName: String){
        print(cityName)
        let cityRegionNoWhiteSpace = "\(cityName.replacingOccurrences(of: " ", with: "").uppercased())/\(region.replacingOccurrences(of: " ", with: "").uppercased())"
        
        Celsius = temp_c
        Fahrenheit = temp_f
        citiesAndRegion = cityRegionNoWhiteSpace
        
        if(!citiesName.contains(cityRegionNoWhiteSpace)){
            citiesName.append(cityRegionNoWhiteSpace)
            citiesWeatherInfos.append(citiesWeatherInfo(cityAndRegion: cityRegionNoWhiteSpace,cityName: cityName.replacingOccurrences(of: " ", with: "").uppercased(), region: region, temp_c: temp_c, temp_f: temp_f, text: text,iconName: iconName, tempFormat: tempFormat))
        }else{
            citiesWeatherInfos = citiesWeatherInfos.map{(city) -> citiesWeatherInfo in
                var city = city
                if (city as citiesWeatherInfo).cityAndRegion == cityRegionNoWhiteSpace {
                    city.temp_c = temp_c
                    city.temp_f = temp_f
                    city.text = text
                    city.iconName = iconName
                    city.tempFormat = tempFormat
                }
                
                return city
            }
        }
        
        print(citiesName)
        print(citiesWeatherInfos)
    }
    
    private func changeCitiesTempFormat(citiesAndRegion:String, tempFormat:String){
        citiesWeatherInfos = citiesWeatherInfos.map{(city) -> citiesWeatherInfo in
            var city = city
            if (city as citiesWeatherInfo).cityAndRegion == citiesAndRegion {
                city.tempFormat = tempFormat
            }
            
            return city
        }
    }
    
}

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get location...")
        
        if let location = locations.last{
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("lating:\(latitude),\(longitude)")
            loadWeather(search: "\(latitude),\(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

