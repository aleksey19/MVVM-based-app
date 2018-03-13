//
//  SectionOfTickerData.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/26/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfTickerData {
    var title: String
    var items: [Ticker]
}

extension SectionOfTickerData: SectionModelType {
    typealias Item = Ticker
    
    init(original: SectionOfTickerData, items: [Item]) {
        self = original
        self.items = items
    }
    
}
