// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DropDownDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let items: [String]
    weak var delegate: DropDownDataSourceDelegate?
    
    init(items: [String]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier, for: indexPath) as? DropDownTableViewCell else { return UITableViewCell() }
        cell.cellLabel.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        delegate?.dropDownDidSelect(item: selectedItem, from: tableView.tag)
        tableView.isHidden = true
        
    }
    
}


protocol DropDownDataSourceDelegate: AnyObject {
    func dropDownDidSelect(item: String, from tag: Int)
}
