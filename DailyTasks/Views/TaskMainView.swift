//
//  TaskView.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import UIKit

class TaskMainView: UIView {
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .clear
        searchBar.backgroundImage = UIImage()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            
            if let searchIcon = textField.leftView as? UIImageView {
                searchIcon.tintColor = .white
            }
            
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray
            ]
        }
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .black
        
        addSubViews(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 60)
        
        tableView.tableHeaderView = createHeaderView()
//        tableView.tableFooterView = createFooterView()
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        headerView.addSubview(searchBar)
        headerView.frame.size = CGSize(width: screenWidth, height: searchBar.frame.height)
        return headerView
    }
    
//    private func createFooterView() -> UIView {
//        let footerView = TableFooterView()
//        footerView.frame.size = CGSize(width: screenWidth, height: 60)
//        
//        return footerView
//    }
    
}
