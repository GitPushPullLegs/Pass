//
//  PreviewPassViewController.swift
//  Pass
//
//  Created by Jose Aguilar on 4/20/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class PreviewPassViewController: UIViewController, PassMenuDelegate, ErrorProtocol {

    let pass: PassM
    init(pass: PassM) {
        self.pass = pass
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        setupPassView()
        setupTableView()
        observe()
    }

    //MARK: - Navbar

    lazy var editButton: UIBarButtonItem = {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditPress))
        return editButton
    }()

    private func setupNavbar() {
        self.title = pass.title
        navigationItem.setRightBarButton(editButton, animated: true)
    }

    @objc private func handleEditPress() {
        let modifyVC = ModifyPassViewController(state: .update(pass))
        navigationController?.pushViewController(modifyVC, animated: true)
    }

    //MARK: - PassMenuTableView

    lazy var passMenu = PassMenuTableView(pass: pass)

    private func setupTableView() {
        passMenu.passMenuDelegate = self
        view.addSubview(passMenu)

        let safeArea = self.view.safeAreaLayoutGuide
        passMenu.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        passMenu.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        passMenu.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        passMenu.bottomAnchor.constraint(equalTo: passView.topAnchor).isActive = true
    }

    func passMenu(didSelectAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1: ExtensionHandler.setWatch(toPass: pass); watchReminder()
        case 2: ExtensionHandler.setWidget(toPass: pass)
        default: print("Shouldn't ever print")
        }
    }

    // Just so people don't think nothing happened.
    func watchReminder() {
        let alertController = UIAlertController(title: "Refresh", message: "If the pass on your watch doesn't immediately change force touch the watch's screen and press reload.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor(asset: .primary)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }

    //MARK: - PassView

    lazy var passView = PassView(pass: pass)

    private func setupPassView() {
        view.addSubview(passView)

        let safeArea = self.view.safeAreaLayoutGuide
        passView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        passView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        passView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

    //MARK: - Realm Observer

    var token: NotificationToken?
    private func observe() {
        token = pass.observe({ [weak self] (changes) in
            switch changes {
            case .change(let properties):
                for property in properties where property.name == "title" {
                    self?.title = property.newValue as? String
                }
            case .deleted:
                self?.token?.invalidate()
                self?.navigationController?.popViewController(animated: true)
            case .error:
                self?.presentError(withTitle: "Something wen't wrong", withText: "If the error persists please email me.")
            }
        })
    }
}
