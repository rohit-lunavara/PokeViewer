//
//  PokeDetailViewController.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    private var pokemon : Pokemon!
    var pokemonDataSource = PokemonDataSource()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spriteImageView: UIImageView!
    @IBOutlet var frontBackBtn: UIButton!
    @IBOutlet var normalShinyBtn: UIButton!
    @IBOutlet var spriteStackView: UIStackView!
    
    private var frontBackSprite = PokemonPosition.front
    private var normalShinySprite = PokemonColor.normal
    
    private var downloadingIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTableView()
        configureButtons()
        didStartLoading()
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            self?.pokemonDataSource.fetchPokemon()
        }
    }
    
    func configureTableView() {
        pokemonDataSource.configure(viewController: self)
        tableView.dataSource = pokemonDataSource
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Cell.DetailCell)
        let statsNib = UINib(nibName: K.Cell.StatDetailCell, bundle: nil)
        tableView.register(statsNib, forCellReuseIdentifier: K.Cell.StatDetailCell)
        let abilitiesNib = UINib(nibName: K.Cell.AbilityDetailCell, bundle: nil)
        tableView.register(abilitiesNib, forCellReuseIdentifier: K.Cell.AbilityDetailCell)
    }
    
    func configureButtons() {
        for btn in [frontBackBtn, normalShinyBtn] {
            guard let btn = btn else { continue }
            btn.layer.cornerRadius = btn.frame.width / 20
            btn.layer.borderWidth = btn.frame.width / 100
            btn.clipsToBounds = true
            
            btn.layer.borderColor = K.Buttons.borderColor.cgColor
            btn.layer.backgroundColor = K.Buttons.backgroundColor.cgColor
            
            btn.setTitleColor(K.Buttons.textColor, for: .normal)
        }
    }
    
    @IBAction func flipSpriteTapped() {
        frontBackSprite.toggle()
        
        updateSprite()
    }
    
    @IBAction func flipSpriteColorTapped() {
        normalShinySprite.toggle()
        
        updateSprite()
    }
    
    func didStartLoading() {
        downloadingIndicator = UIActivityIndicatorView(frame: view.frame)
        downloadingIndicator.startAnimating()
        downloadingIndicator.backgroundColor = .white
        view.addSubview(downloadingIndicator)
        
        spriteStackView.isHidden = true
    }
    
    func didFinishLoading() {
        DispatchQueue.main.async {
            [weak self] in
            self?.downloadingIndicator.stopAnimating()
            self?.downloadingIndicator.removeFromSuperview()
        }
    }
}

//MARK: - Sprite Update Methods

extension PokemonDetailViewController {
    func updateSprite() {
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            if let frontBackSprite = self?.frontBackSprite, let normalShinySprite = self?.normalShinySprite {
                self?.pokemonDataSource.getPokemonSprite(orientation: frontBackSprite, color: normalShinySprite)
                DispatchQueue.main.async {
                    self?.frontBackBtn?.setTitle(frontBackSprite.oppositeName, for: .normal)
                    self?.normalShinyBtn?.setTitle(normalShinySprite.oppositeName, for: .normal)
                }
            }
        }
    }
    
    func didUpdateSprite(with image : UIImage?) {
        DispatchQueue.main.async {
            [weak self] in
            guard let image = image else {
                return
            }
            self?.spriteImageView.image = image
            self?.spriteStackView.isHidden = false
        }
    }
}
