//
//  StoreVC.swift
//  HealEat
//
//  Created by 이태림 on 1/20/25.
//

import UIKit
import Then

class StoreVC: UIViewController {
    
    let data = dummyStoreModel.storeDatas
    
    private lazy var storeview = StoreView().then {
        $0.backgroundColor = .white
        $0.storeTableView.backgroundColor = .white
        $0.storeTableView.dataSource = self
        $0.storeTableView.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = storeview
        self.storeview.storeTableView.reloadData()
    }
}

extension StoreVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = storeview.storeTableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.identifier, for: indexPath) as? StoreTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: data[indexPath.row])
        
        return cell
    }
}
