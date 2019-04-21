//
//  PassMenuTableView.swift
//  Pass
//
//  Created by Jose Aguilar on 4/20/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

protocol PassMenuDelegate: class {
    func passMenu(didSelectAt indexPath: IndexPath)
}

class PassMenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    weak var passMenuDelegate: PassMenuDelegate?

    let pass: PassM
    init(pass: PassM) {
        self.pass = pass
        super.init(frame: .zero, style: .plain)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.backgroundColor = .white
        self.bounces = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
    }

    //MARK: - Cells

    lazy var menuCell: UITableViewCell = {
        let menuCell = UITableViewCell()
        menuCell.textLabel?.text = "Extensions"
        menuCell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        menuCell.preservesSuperviewLayoutMargins = false
        menuCell.separatorInset = .zero
        menuCell.layoutMargins = .zero
        menuCell.tintColor = UIColor(asset: .primary)
        return menuCell
    }()
    var addToSiriCell: UITableViewCell = {
        let addToSiriCell = UITableViewCell(style: .subtitle, reuseIdentifier: "atsc")
        addToSiriCell.textLabel?.text = "Add to Siri"
        addToSiriCell.detailTextLabel?.text = "Siri can show you your pass without even having to unlock your phone."
        addToSiriCell.detailTextLabel?.numberOfLines = 0
        addToSiriCell.detailTextLabel?.lineBreakMode = .byWordWrapping
        addToSiriCell.detailTextLabel?.textColor = .gray
        return addToSiriCell
    }()
    var addToWidgetCell: UITableViewCell = {
        let addToWidgetCell = UITableViewCell(style: .subtitle, reuseIdentifier: "atwc")
        addToWidgetCell.textLabel?.text = "Set Widget"
        addToWidgetCell.detailTextLabel?.text = "Your pass will be readily available in the lockscreen widget."
        addToWidgetCell.detailTextLabel?.numberOfLines = 0
        addToWidgetCell.detailTextLabel?.lineBreakMode = .byWordWrapping
        addToWidgetCell.detailTextLabel?.textColor = .gray
        return addToWidgetCell
    }()

    //MARK: - TableView

    var isCollapsed = true

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCollapsed ? 1 : 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return menuCell
        case 1: return addToSiriCell
        case 2: return addToWidgetCell
        default: return UITableViewCell() // Not worth crashing over.
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            isCollapsed = !isCollapsed
            toggleRows()
        default:
            passMenuDelegate?.passMenu(didSelectAt: indexPath)
        }
    }

    var collapsibleIndexPaths = [IndexPath(row: 1, section: 0),
                                      IndexPath(row: 2, section: 0)]

    private func toggleRows() {
        self.beginUpdates()
        if isCollapsed {
            self.deleteRows(at: collapsibleIndexPaths, with: .automatic)
        } else {
            self.insertRows(at: collapsibleIndexPaths, with: .automatic)
        }
        self.endUpdates()
    }
}
