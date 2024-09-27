//
//  CitiesTableViewCell.swift
//  WeatherApp
//
//  Created by Nicole Xia on 2024-07-12.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
  
    @IBOutlet weak var weatherTextLabel: UILabel!
    
    @IBOutlet weak var weatherIconImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
