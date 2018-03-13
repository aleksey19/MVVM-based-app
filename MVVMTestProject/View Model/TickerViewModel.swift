//
//  TickerViewModel.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/30/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TickerViewModel {
    let bag = DisposeBag()
    var navigator: Navigator!
    var api: API!
    
    // MARK: - Output
    var ticker: Observable<Ticker>!
    
    // MARK: - Init
    init(navigator: Navigator, api: API, tickerId: String) {
        self.navigator = navigator
        self.api = api
        self.ticker = api.ticker(id: tickerId, returnCurrency: nil)
    }
}
