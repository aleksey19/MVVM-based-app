//
//  TickerViewController.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/31/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TickerViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!

    let bag = DisposeBag()
    var viewModel: TickerViewModel!
    let usdPriceFormatter = NumberFormatter()
    let btcPriceFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usdPriceFormatter.maximumFractionDigits = 2
        usdPriceFormatter.minimumSignificantDigits = 1
        btcPriceFormatter.maximumFractionDigits = 8
        btcPriceFormatter.minimumSignificantDigits = 1
        
        bindUI()
    }
    
    func bindUI() {
        let datasource = RxTableViewSectionedReloadDataSource<SectionOfTickerData>(configureCell: { [weak self](_, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "DetailTickerTableViewCell", for: ip) as! DetailTickerTableViewCell
            cell.fill(ticker: item, usdPriceFormatter: (self?.usdPriceFormatter)!, btcPriceFormatter: (self?.btcPriceFormatter)!)
            
            return cell
        })
        
        viewModel.ticker
            .subscribe(onNext: { [weak self] ticker in
                let sections = [SectionOfTickerData(title: "", items: [ticker])]                
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.messageViewHeightConstraint.constant = 0

                    Observable.just(sections)
                        .bind(to: strongSelf.tableView.rx.items(dataSource: datasource))
                        .disposed(by: strongSelf.bag)
                    
                    strongSelf.title = ticker.symbol
                }
            })
            .disposed(by: bag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}
