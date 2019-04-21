//
//  PreviewPassViewController.swift
//  Pass
//
//  Created by Jose Aguilar on 4/20/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class PreviewPassViewController: UIViewController, PassMenuDelegate {

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
        setupTableView()
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

    func setupTableView() {
        passMenu.passMenuDelegate = self
        view.addSubview(passMenu)

        let safeArea = self.view.safeAreaLayoutGuide
        passMenu.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        passMenu.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        passMenu.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        passMenu.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

    func passMenu(didSelectAt indexPath: IndexPath) {
        print(indexPath)
    }
}
