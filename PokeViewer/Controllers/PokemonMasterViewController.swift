//
//  ViewController.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonMasterViewController: UITableViewController {
    var pokemonNameDataSource = PokemonNameDataSource()
    var pokemonNameDelegate = PokemonNameDelegate()
    var pokemonNameSearchBarDelegate = PokemonNameSearchBarDelegate()
    
    @IBOutlet var pokemonNameSearchBar: UISearchBar!
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = K.appName
        
        configureTableView()
        configureSearchBar()
        addKeyboardNotifications()
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            self?.pokemonNameDataSource.getNames(for: .first)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }
    
    func configureTableView() {
        pokemonNameDataSource.configure(viewController : self)
        pokemonNameDelegate.configure(viewController : self)
        
        tableView.dataSource = pokemonNameDataSource
        let loadingNib = UINib(nibName: K.Cell.LoadingCell, bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: K.Cell.LoadingCell)
        tableView.delegate = pokemonNameDelegate
    }
    
    func configureSearchBar() {
        pokemonNameSearchBar.delegate = pokemonNameSearchBarDelegate
        pokemonNameSearchBarDelegate.configure(dataSource : pokemonNameDataSource)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: pokemonNameSearchBar, action: #selector(pokemonNameSearchBar.becomeFirstResponder))
    }
    
    func scrollViewDidReachEnd() {
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            self?.pokemonNameDataSource.getNames(for: .next)
        }
    }
}

//MARK: - Adjusting UI when Keyboard is shown

extension PokemonMasterViewController {
    func addKeyboardNotifications() {
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        notificationCenter.removeObserver(self)
    }
    
    @objc func adjustKeyboard(_ notification : Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenFrame, from: view.window)
        
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            tableView.contentInset = .zero
        default:
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}
