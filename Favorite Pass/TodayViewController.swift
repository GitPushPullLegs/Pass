//
//  TodayViewController.swift
//  Favorite Pass
//
//  Created by Jose Aguilar on 4/20/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    var passTitleLabel: UILabel = {
        let passTitleLabel = UILabel()
        passTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        passTitleLabel.numberOfLines = 0
        passTitleLabel.lineBreakMode = .byWordWrapping
        passTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return passTitleLabel
    }()
    var passCodeLabel: UILabel = {
        let passCodeLabel = UILabel()
        passCodeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        passCodeLabel.textAlignment = .right
        passCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        return passCodeLabel
    }()
    var passImageView: UIImageView = {
        let passImageView = UIImageView()
        passImageView.translatesAutoresizingMaskIntoConstraints = false
        return passImageView
    }()

    lazy var defaults = UserDefaults(suiteName: "group.joeyisthebest.Pass.Today")
    var defaultsKeys = (title: "title", code: "code", isCode39: "isCode39", imageData: "imageData")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        guard let imageData = defaults?.data(forKey: defaultsKeys.imageData) else {
            nilGuard(); return
        }

        passTitleLabel.text = defaults?.string(forKey: defaultsKeys.title)
        passCodeLabel.text = defaults?.string(forKey: defaultsKeys.code)
        passImageView.image = UIImage(data: imageData)

        view.addSubview(passTitleLabel); view.addSubview(passCodeLabel); view.addSubview(passImageView)
        makeConstraints()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        preferredContentSize = activeDisplayMode == .expanded ? CGSize(width: 0.0, height: 220) : maxSize
    }

    private func makeConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        passTitleLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 8).isActive = true
        passTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
        passTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor, multiplier: 0.66).isActive = true
        passTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        passCodeLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -8).isActive = true
        passCodeLabel.centerYAnchor.constraint(equalTo: passTitleLabel.centerYAnchor).isActive = true
        passCodeLabel.leftAnchor.constraint(equalTo: passTitleLabel.rightAnchor, constant: 4).isActive = true

        passImageView.topAnchor.constraint(equalTo: passTitleLabel.bottomAnchor, constant: 8).isActive = true
        passImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8).isActive = true

        if defaults?.bool(forKey: defaultsKeys.isCode39) ?? false {
            passImageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 8).isActive = true
            passImageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -8).isActive = true
        } else {
            passImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            passImageView.widthAnchor.constraint(equalTo: passImageView.heightAnchor).isActive = true
        }
    }

    private func nilGuard() {
        view.addSubview(passTitleLabel)

        let safeArea = view.safeAreaLayoutGuide
        passTitleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        passTitleLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        passTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor, constant: -16).isActive = true
        passTitleLabel.heightAnchor.constraint(lessThanOrEqualTo: safeArea.heightAnchor, constant: -16).isActive = true

        passTitleLabel.text = "You must first set a pass as your favorite within the app."
    }
}
