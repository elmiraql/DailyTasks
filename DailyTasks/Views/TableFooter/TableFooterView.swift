//
//  TableFooterView.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 25.03.25.
//

import UIKit

class TableFooterView: UIView {
    
    var addTask: (()->())?
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func addClicked(){
        addTask?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .lightGrayColor
        
        addSubViews(label, addButton)
        
        label.centerX(inView: self)
        label.centerY(inView: self)
        addButton.centerY(inView: label)
        addButton.anchor(right: rightAnchor, paddingRight: 32)
    }
}
