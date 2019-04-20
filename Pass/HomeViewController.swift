//
//  ViewController.swift
//  Pass
//
//  Created by Jose Aguilar on 3/16/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        pullData()
        observe()
    }

    //MARK: - Navbar

    lazy var addBarButton: UIBarButtonItem = {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPress))
        return addBarButton
    }()

    private func setupNavbar() {
        title = "Passes"
        navigationController?.navigationBar.tintColor = UIColor(asset: .primary) ?? .red
        let color = UIColor.white.withAlphaComponent(0.9)
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: color), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(addBarButton, animated: true)
    }

    @objc func handleAddPress() {
        let addPassVC = ModifyPassViewController(state: .new)
        navigationController?.pushViewController(addPassVC, animated: true)
    }

    //MARK: - Realm

    var passes: Results<PassM>?
    func pullData() {
        do {
            let realm = try Realm()
            passes = realm.objects(PassM.self)
        } catch {
            print(error)
        }
    }

    var token: NotificationToken?
    private func observe() {
        token = passes?.observe({ [weak self] (changes) in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.tableView.beginUpdates()
                let insertionsMapped = insertions.map({ IndexPath(row: $0, section: 0) })
                let deletionsMapped = deletions.map({ IndexPath(row: $0, section: 0) })
                let modificationsMapped = modifications.map({ IndexPath(row: $0, section: 0) })
                self?.tableView.insertRows(at: insertionsMapped, with: .automatic)
                self?.tableView.deleteRows(at: deletionsMapped, with: .automatic)
                self?.tableView.reloadRows(at: modificationsMapped, with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        })
    }

    //MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = passes?[indexPath.row] else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.code
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pass = passes?[indexPath.row] else { return }
        let previewPassVC = PreviewPassViewController(code: pass)
        navigationController?.pushViewController(previewPassVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
