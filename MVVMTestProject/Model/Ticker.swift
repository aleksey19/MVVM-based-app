//
//  Ticker.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/26/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import Foundation
import SwiftyJSON

class Ticker {
    var id: String
    var name: String
    var symbol: String
    var rank: String
    var priceUSD: Decimal
    var priceBTC: Decimal
    var VolumeUSD24h: Decimal
    var marketCapUSD: Decimal
    var availableSupply: Decimal
    var totalSupply: Decimal
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d: Double
    var lastUpdated: Decimal
    
    init(json: Any) {
        let data = JSON(json)
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        self.symbol = data["symbol"].stringValue
        self.rank = data["rank"].stringValue
        self.priceUSD = Decimal(floatLiteral: data["price_usd"].doubleValue)
        self.priceBTC = Decimal(floatLiteral: data["price_btc"].doubleValue)
        self.VolumeUSD24h = Decimal(floatLiteral: data["24h_volume_usd"].doubleValue)
        self.marketCapUSD = Decimal(floatLiteral: data["market_cap_usd"].doubleValue)
        self.availableSupply = Decimal(floatLiteral: data["available_supply"].doubleValue)
        self.totalSupply = Decimal(floatLiteral: data["total_supply"].doubleValue)
        self.percentChange1h = data["percent_change_1h"].doubleValue
        self.percentChange24h = data["percent_change_24h"].doubleValue
        self.percentChange7d = data["percent_change_7d"].doubleValue
        self.lastUpdated = Decimal(floatLiteral: data["last_updated"].doubleValue)
    }
    
    class func tickers(with json: JSON) -> [Ticker] {
        return json.map { (arg) -> Ticker in                        
            return Ticker(json: arg.1.rawValue)
        }
    }        
}
