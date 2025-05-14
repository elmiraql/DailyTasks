//
//  TaskDetailView.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 24.03.25.
//

import UIKit

class TaskDetailView: UIView, UITextViewDelegate {
    
    var title: UITextView = {
        let title = UITextView()
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 36)
        title.textColor = .white
        title.backgroundColor = .black
        title.isScrollEnabled = false
        title.sizeToFit()
        return title
    }()
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Заголовок"
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 41)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    var descTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .black
        
        addSubViews(title, dateLabel, descTextView, placeholderLabel)
        
        title.delegate = self
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            title.heightAnchor.constraint(lessThanOrEqualToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: 5),
            placeholderLabel.topAnchor.constraint(equalTo: title.topAnchor, constant: 8) // Немного вниз
        ])
        
        dateLabel.anchor(top: title.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        descTextView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        updatePlaceholderVisibility()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    func setTitleText(_ text: String?) {
        title.text = text
        updatePlaceholderVisibility() 
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !title.text.isEmpty
    }
}
