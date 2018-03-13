//
//  TickerTableViewCell.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/26/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit

class TickerTableViewCell: UITableViewCell {
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    
    func fill(ticker: Ticker, formatter: NumberFormatter) {        
        nameLabel.text = ticker.name
        priceLabel.text = "Price: " + "$\(formatter.string(from: ticker.priceUSD as NSNumber)!)"
        marketCapLabel.text = "Market cap: " + "$\(formatter.string(from: ticker.marketCapUSD as NSNumber)!)"
        
        let image = (UIImage(named: ticker.id) != nil) ? UIImage(named: ticker.id) : UIImage(named: "crypto-currency")        
        coinImageView.image = image
    }
}
