//
//  MainScene.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/31/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import Then

enum Scene {
    case tickers(TickersViewModel)
    case ticker(TickerViewModel)
}

extension Scene: SceneCompatible {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .tickers(let viewModel):
            let tickersViewController = storyboard.instantiateViewController(ofType: TickersViewController.self).then { vc in
                vc.viewModel = viewModel
            }
            return tickersViewController
        
        case .ticker(let viewModel):
            let tickerViewController = storyboard.instantiateViewController(ofType: TickerViewController.self).then { vc in
                vc.viewModel = viewModel
            }
            return tickerViewController            
        }
    }
}
