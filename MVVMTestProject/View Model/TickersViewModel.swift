//
//  WeatherViewModel.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/24/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class TickersViewModel {
    private let bag = DisposeBag()
    private let api: API!
    private var navigator: Navigator!
    
    // MARK: - Input
    private(set) var selectedIndexPathVariable: Variable<IndexPath?>!
    
    // MARK: - Output
    private(set) var tickers: Observable<[Ticker]>!
    private var tickersIds: ReplaySubject<String?>! // Keep id's of tickers to pass them to detail view
    
    // MARK: - Init
    init(navigator: Navigator, api: API) {
        self.navigator = navigator
        self.api = api
        self.tickers = api.tickers(limit: "15", returnCurrency: nil)
        self.selectedIndexPathVariable = Variable(nil)
        self.tickersIds = ReplaySubject.createUnbounded()
        
        bind()
    }
    
    // MARK: - Private
    private func bind() {
        selectedIndexPathVariable.asObservable()
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.tickersIds
                    .elementAt((indexPath?.row)!)
                    .subscribe(onNext: { (tickerId) in
                        let tickerViewModel = TickerViewModel(navigator: strongSelf.navigator, api: strongSelf.api, tickerId: tickerId!)
                        DispatchQueue.main.async {
                            strongSelf.navigator.perform(scene: Scene.ticker(tickerViewModel), sender: nil, segue: Segue.tickerDetail)
                        }

                    })
                    .disposed(by: strongSelf.bag)
            })
            .disposed(by: bag)
        
        tickers.subscribe(onNext: { [weak self] (tickers) in
            if let strongSelf = self {
                tickers.forEach({ ticker in
                    strongSelf.tickersIds.onNext(ticker.id)
                })
            }
        })
            .disposed(by: bag)
        
        
        //
        
    }
    
}
