//
//  UIApplication+Rx.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 11/17/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxUIApplicationDelegateProxy: DelegateProxy<AnyObject, AnyObject>, UIApplicationDelegate, DelegateProxyType {
    static func registerKnownImplementations() { }
    
    static func currentDelegate(for object: AnyObject) -> AnyObject? {
        let application: UIApplication = object as! UIApplication
        return application
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, to object: AnyObject) {
        var application: UIApplication = object as! UIApplication
        application = (delegate as? UIApplication)!
    }
}

extension Reactive where Base: UIApplication {
    var delegate: DelegateProxy<AnyObject, AnyObject> {
        return RxUIApplicationDelegateProxy.proxy(for: base)
    }
    
    var isNetworkActivityIndicatorVisible: Observable<Bool> {
        return delegate.methodInvoked(#selector(getter: UIApplication.isNetworkActivityIndicatorVisible))
            .map({ visibles in
                return visibles[1] as! Bool
            })
    }
    
    
}
