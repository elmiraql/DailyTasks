//
//  MyTaskCell.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import UIKit

protocol MyTaskCellDelegate: AnyObject {
    func didToggleTaskCompletion(cell: MyTaskCell, isCompleted: Bool)
}

class MyTaskCell: UITableViewCell {
    
    weak var delegate: MyTaskCellDelegate?
    
    var task: MyTask? {
        didSet {
            configure()
        }
    }
    
    var stateChanged: ((Bool) -> ())?
    var isCompleted: Bool = false
    
    var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "undone"), for: .normal)
        button.setImage(UIImage(named: "done"), for: .selected)
        button.addTarget(self, action: #selector(changeState), for: .touchUpInside)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var taskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .white
//        label.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews(){
        backgroundColor = .black
        selectionStyle = .none
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, taskDescriptionLabel, dateLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 8
        
        let hStack = UIStackView(arrangedSubviews: [doneButton, vStack])
        hStack.alignment = .leading
        hStack.spacing = 8
        
        contentView.addSubViews(hStack)
        
        hStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeState))
        titleLabel.addGestureRecognizer(tapGesture)
        
        contentView.addSubview(divider)
        divider.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, height: 1)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let task = task else { return }
        titleLabel.text = task.todo
        dateLabel.text = "23/03/2025"
        taskDescriptionLabel.text = task.taskText
        doneButton.isSelected = task.completed ?? false
        isCompleted = task.completed ?? false
        
        strikeTroughText(isCompleted: task.completed ?? false, text: task.todo ?? "")
    }
    
    @objc private func changeState() {
        doneButton.isSelected.toggle()
        stateChanged?(doneButton.isSelected)

        strikeTroughText(isCompleted: doneButton.isSelected, text: task?.todo ?? "")
        
        delegate?.didToggleTaskCompletion(cell: self, isCompleted: doneButton.isSelected)
    }
    
    func strikeTroughText(isCompleted: Bool, text: String){
        if doneButton.isSelected {
            let attributedString = NSMutableAttributedString(string: text)
               attributedString.addAttribute(.strikethroughStyle,
                                              value: NSUnderlineStyle.single.rawValue,
                                             range: NSRange(location: 0, length: isCompleted ? (text.count ?? 0) : 0))
               titleLabel.attributedText = attributedString
           } else {
               titleLabel.attributedText = NSAttributedString(string: text)
           }
    }
    
}
