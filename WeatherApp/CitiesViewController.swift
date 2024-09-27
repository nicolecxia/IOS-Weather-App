//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Nicole Xia on 2024-07-12.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var cities:[citiesWeatherInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set navigator bar title color
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        title = "Weather List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension CitiesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("This cell from the chat list was selected: \(indexPath.row)")
        
        tableView.deselectRow(at: indexPath, animated: true)
        let isChecked = tableView.cellForRow(at: indexPath)?.accessoryType == .disclosureIndicator
        if(isChecked){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}

extension CitiesViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CitiesTableViewCell
        
        cell?.cityNameLabel.text = cities[indexPath.row].cityName.capitalized
         cell?.regionLabel.text = cities[indexPath.row].region
         cell?.weatherTextLabel.text = cities[indexPath.row].text
        
        let config = UIImage.SymbolConfiguration(paletteColors: [
            UIColor.systemBlue,.systemYellow,.systemTeal
        ])
        cell?.weatherIconImage.preferredSymbolConfiguration = config
        cell?.weatherIconImage.image = UIImage(systemName: cities[indexPath.row].iconName)
        
        if cities[indexPath.row].tempFormat == "C" {
            cell?.tempLabel.text = "\(cities[indexPath.row].temp_c)C"
        }else{
            cell?.tempLabel.text = "\(cities[indexPath.row].temp_f)F"
        }
         
        
        
        return cell ?? UITableViewCell()
    }
}
