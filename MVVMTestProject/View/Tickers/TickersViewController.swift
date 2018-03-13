//
//  TickersViewController.swift
//  MVVMTestProject
//
//  Created by Alexey Bidnyk on 10/26/17.
//  Copyright © 2017 Alexey Bidnyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TickersViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: TickersViewModel!
    fileprivate let bag = DisposeBag()
    fileprivate let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.minimumSignificantDigits = 1
        formatter.maximumFractionDigits = 2
        
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ?
    }
    
    func bindUI() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTickerData>(configureCell: { [weak self] (_, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "TickerTableViewCell", for: ip) as! TickerTableViewCell
            cell.fill(ticker: item, formatter: (self?.formatter)!)
            
            return cell
        })
        
        viewModel.tickers
            .subscribe(onNext: { [weak self] tickers in
                let sections = [SectionOfTickerData(title: "", items: tickers)]
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.messageViewHeightConstraint.constant = 0
                    
                    Observable.just(sections)
                        .bind(to: strongSelf.tableView.rx.items(dataSource: dataSource))
                        .disposed(by: strongSelf.bag)
                }
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected.asObservable()
            .bind(to: viewModel.selectedIndexPathVariable)
            .disposed(by: bag)
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
