//
//  API.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/24/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

typealias JSONObject = [String: Any]

protocol APIProtocol {
    func tickers(limit: String?, returnCurrency: String?) -> Observable<[Ticker]>
    func ticker(id: String, returnCurrency: String?) -> Observable<Ticker>
//    func globalData(returnCurrency: String?) -> Observable<Ticker>
}

class API: APIProtocol {
    
    let baseURL: String = "https://api.coinmarketcap.com/v1"
    let bag = DisposeBag()
    
    lazy var retryHandler: (Observable<Error>) -> Observable<Int> = { e in
        let maxAttemptsCount = 4
        return e.flatMapWithIndex { (error, attempt) -> Observable<Int> in
            if attempt >= maxAttemptsCount - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                return RxReachability.shared.status.filter { $0 == .online }.map { _ in return 1 }
            }
            print("== retry attempt: \(attempt)")
            return Observable<Int>.timer(Double(attempt + 1), scheduler: MainScheduler.instance).take(1)
        }
    }
    
    private(set) lazy var requestInProcess: Variable<Bool> = Variable(false)
    
    init() {
        requestInProcess.asDriver()
            .drive(onNext: { (isNetworking) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isNetworking
        })
            .disposed(by: bag)
    }
    
    // MARK: - API Addresses
//    fileprivate enum Address: String {
//        case tickers = "/ticker/"
//        case ticker = "/ticker/*/"
//        case globalData = "/global/"
//
//        var baseURL: String { return "https://api.coinmarketcap.com/v1" }
//        var url: URL {
//            return URL(string: baseURL.appending(rawValue))!
//        }
//
//    }
    
    // MARK: - API errors
    enum Errors: Error {
        case requestFailed
        case badResponse
        case httpError(Int)
    }
    
    // MARK: - APIProtocol
    func tickers(limit: String?, returnCurrency: String?) -> Observable<[Ticker]> {
        let parameters = [
            "limit" : limit,
            "convert" : returnCurrency
        ]
        
        return request(pathComponent: "/ticker/", parameters: parameters).map({ json in
            return Ticker.tickers(with: json)
        })
    }
    
    func ticker(id: String, returnCurrency: String?) -> Observable<Ticker> {
        let parameters = [
            "convert" : returnCurrency
        ]
        
        return request(pathComponent: "/ticker/\(id)/", parameters: parameters).map({ json in
            return Ticker.tickers(with: json).first!
        })
    }
    
//    func globalData(returnCurrency: String?) -> Observable<Ticker> {
//        return Observable.empty()
//    }
    
    // MARK: - Generic request
    private func request(method: String = "GET", pathComponent: String, parameters: [String: String?]) -> Observable<JSON> {
        requestInProcess.value = true
        
        let url = URL(string: baseURL.appending(pathComponent))!
        var request: URLRequest
        
        if method == "POST" {
            var bodyString: String = ""
            for item in parameters.enumerated() {
                if let value = item.element.value {
                    bodyString = bodyString + "\(item.element.key)=\(String(describing: value))"
                }
                
                if (item.offset < parameters.capacity - 1) {
                    bodyString = bodyString + "&"
                }
            }
            request = URLRequest(url: url)
            request.httpBody = bodyString.data(using: String.Encoding.utf8)
        } else {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            urlComponents.queryItems = parameters.map { (key, value) in
                return URLQueryItem(name: key, value: value)
            }
            
            request = URLRequest(url: urlComponents.url!)
        }
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        return session.rx.data(request: request)
            .retryWhen(retryHandler)
            .map { [weak self] (data) in
                if let strongSelf = self {
                    strongSelf.requestInProcess.value = false
                }
                return JSON(data)
            }
        
    }
}
