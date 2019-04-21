//
//  PassView.swift
//  Pass
//
//  Created by Jose Aguilar on 3/16/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class PassView: UIView {

    let pass: PassM
    init(pass: PassM) {
        self.pass = pass
        super.init(frame: CGRect.zero)
        addSubviews()
        makeSharedConstraints()
        switch pass.isCode39 {
        case true: makeCode39Constraints()
        case false: makeQRConstraints()
        }
        observe()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Subviews

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = pass.image
        return imageView
    }()
    lazy var codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        codeLabel.textAlignment = .center
        codeLabel.highlightedTextColor = UIColor(asset: .primary) ?? .red
        codeLabel.text = pass.code
        return codeLabel
    }()

    private func addSubviews() {
        self.addSubview(imageView)
        self.addSubview(codeLabel)
    }

    var code39HeightConstraint: NSLayoutConstraint?
    var code39WidthConstraint: NSLayoutConstraint?
    var qrHeightConstraint: NSLayoutConstraint?
    var qrWidthConstraint: NSLayoutConstraint?

    private func makeSharedConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide
        imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8).isActive = true
        imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true

        codeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        codeLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -8).isActive = true
        codeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true

        code39HeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 100)
        code39WidthConstraint = imageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -16)
        qrHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 150)
        qrWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 150)
    }

    private func makeCode39Constraints() {
        qrHeightConstraint?.isActive = false
        qrWidthConstraint?.isActive = false
        code39HeightConstraint?.isActive = true
        code39WidthConstraint?.isActive = true
    }

    private func makeQRConstraints() {
        code39HeightConstraint?.isActive = false
        code39WidthConstraint?.isActive = false
        qrHeightConstraint?.isActive = true
        qrWidthConstraint?.isActive = true
    }

    //MARK: - Realm Observer

    var token: NotificationToken?
    private func observe() {
        token = pass.observe({ [weak self] (changes) in
            switch changes {
            case .change(let properties):
                for property in properties {
                    if property.name == "code" {
                        self?.codeLabel.text = property.newValue as? String
                        self?.imageView.image = self?.pass.image
                    } else if property.name == "isCode39" {
                        guard let newValue = property.newValue as? Bool else { break }
                        if newValue {
                            self?.makeCode39Constraints()
                        } else {
                            self?.makeQRConstraints()
                        }
                    }
                }
            case .deleted:
                self?.token?.invalidate()
            case .error(let error):
                self?.codeLabel.text = "Failed to load due to error \(error)."
            }
        })
    }
}
