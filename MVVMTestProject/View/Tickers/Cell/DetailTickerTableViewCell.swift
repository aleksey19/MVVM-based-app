//
//  DetailTickerTableViewCell.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 11/14/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import Foundation

class DetailTickerTableViewCell: UITableViewCell {
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceUSDLabel: UILabel!
    @IBOutlet weak var priceBTCLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volume24HLabel: UILabel!
    
    func fill(ticker: Ticker, usdPriceFormatter: NumberFormatter, btcPriceFormatter: NumberFormatter) {
        let priceChangeColor = (ticker.percentChange24h > 0) ? UIColor(red: 108 / 255.0, green: 183 / 255.0, blue: 96 / 255.0, alpha: 1.0) : UIColor(red: 237 / 255.0, green: 87 / 255.0, blue: 71 / 255.0, alpha: 1.0)
        let attributes = [NSAttributedStringKey.foregroundColor : priceChangeColor]
        
        let priceUSD = "$\(usdPriceFormatter.string(from: ticker.priceUSD as NSNumber)!)"
        let priceUSD24HChange = "(\(usdPriceFormatter.string(from:ticker.percentChange24h as NSNumber)!)%)"
        let attributedPriceUSDChange = NSAttributedString(string: priceUSD24HChange, attributes: attributes as [NSAttributedStringKey : Any])
        let attributedPriceUSD = NSMutableAttributedString(string: priceUSD, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        attributedPriceUSD.append(attributedPriceUSDChange)
        
        nameLabel.text = ticker.name
        symbolLabel.text = ticker.symbol
        priceUSDLabel.attributedText = attributedPriceUSD
        priceBTCLabel.text = "\(btcPriceFormatter.string(from: ticker.priceBTC as NSNumber)!) BTC"
        marketCapLabel.text = "$\(usdPriceFormatter.string(from: ticker.marketCapUSD as NSNumber)!)"
        volume24HLabel.text = "$\(usdPriceFormatter.string(from: ticker.VolumeUSD24h as NSNumber)!)"
        
        guard let image = UIImage(named: ticker.id) else {
            return
        }
        
        coinImageView.image = image
    }
}
