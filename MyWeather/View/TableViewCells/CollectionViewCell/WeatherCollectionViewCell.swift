//
//  WeatherCollectionViewCell.swift
//  MyWeather
//
//  Created by Darrell Bowdon on 6/16/21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    
    func configure(with model: WeatherViewModel) {
        self.tempLabel.text = "\(Int(model.temp))°"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(systemName: model.conditionName)
        self.hourLabel.text = getHourForDate(Date(timeIntervalSince1970: Double(model.dt)))
    }
    
    func getHourForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: inputDate)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
