//
//  Navigator.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/26/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SceneCompatible {
    func viewController() -> UIViewController
}

enum Segue {
    case tickersList
    case tickerDetail
}

class Navigator {
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var networkActivityIndicator: Variable<Bool> = Variable(false)
    
    var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    func perform(scene: SceneCompatible, sender: UIViewController?, segue: Segue) -> Observable<Void> {
        switch segue {
        case .tickersList:
            // Show list of coins
            if let senderVC = sender {
                show(target: scene.viewController(), sender: senderVC)
            }
            
        case .tickerDetail:
            // Show detail coin
            show(target: scene.viewController(), sender: self.topViewController())
        }
        
        return Observable.empty()
    }
    
    // MARK: - Private
    private func show(target: UIViewController, sender: UIViewController) {
        if let navController = sender as? UINavigationController {
            // Set root view controller
            navController.pushViewController(target, animated: false)
        } else {
            sender.show(target, sender: sender)
        }
    }
    
    private func topViewController() -> UIViewController {
        guard let navController = window.rootViewController as? UINavigationController else {
            return window.rootViewController!
        }
        
        return navController.topViewController!
    }
}
