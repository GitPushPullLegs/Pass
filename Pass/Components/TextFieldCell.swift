//
//  TextFieldCell.swift
//  Pass
//
//  Created by Jose Aguilar on 3/16/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    override var tintColor: UIColor! {
        didSet {
            textField.tintColor = self.tintColor
        }
    }

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        textField.tintColor = self.tintColor
        textField.placeholder = "Start typing here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.autocapitalizationType = .words

        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        textField.leftView = spacingView
        textField.leftViewMode = .always
        textField.rightView = spacingView
        textField.rightViewMode = .always
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(textField)
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        textField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -8).isActive = true
        textField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4).isActive = true
        textField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -4).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func addTarget(target: Any?, action: Selector, forControlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: forControlEvents)
    }
}
