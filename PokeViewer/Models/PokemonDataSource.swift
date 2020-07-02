//
//  PokemonDataSource.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/29/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonDataSource : NSObject, UITableViewDataSource {
    var viewController : PokemonDetailViewController!
    let requestManager = RequestManager()
    
    var pokemonName : PokemonName!
    var currentPokemon : Pokemon?
    var fetchingMore = false
    
    func configure(viewController : PokemonDetailViewController) {
        self.viewController = viewController
        requestManager.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return currentPokemon?.types.count ?? 0 < 2 ? "Type" : "Types"
        case 1:
            return currentPokemon?.abilities.count ?? 0 < 2 ? "Ability" : "Abilities"
        case 2:
            return "Stats"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentPokemon?.types.count ?? 0
        case 1:
            return currentPokemon?.abilities.count ?? 0
        case 2:
            return currentPokemon?.stats.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.DetailCell, for: indexPath)
            
            if let types = currentPokemon?.types[indexPath.row] {
                cell.textLabel?.text = types.type.name
                cell.backgroundColor = K.Types.getTypeColor(for: types.type.name.lowercased())
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.AbilityDetailCell, for: indexPath) as! AbilityDetailCell
            
            if let abilities = currentPokemon?.abilities[indexPath.row] {
                
                cell.abilityLabel.text = abilities.ability.name
                cell.abilityHiddenImageView.image = abilities.is_hidden ? K.Ability.hidden : K.Ability.normal
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.StatDetailCell, for: indexPath) as! StatDetailCell
            
            if let stats = currentPokemon?.stats[indexPath.row] {
                cell.textLabel?.text = stats.stat.name
                cell.detailTextLabel?.text = "\(stats.base_stat)"
                cell.backgroundColor = K.Stats.getStatColor(for: stats.base_stat)
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.DetailCell, for: indexPath)
            
            return cell
        }
    }
}

//MARK: - Fetch and Load Data

extension PokemonDataSource {
    func fetchPokemon() {
        let urlString = pokemonName.url
        fetchingMore = true
        requestManager.makeRequest(with: urlString, type: .json)
    }
    
    func loadData() {
        var firstColor = UIColor.systemBackground
        var secondColor = UIColor.systemBackground
        if let currentPokemon = currentPokemon {
            switch currentPokemon.types.count {
            case 1:
                firstColor = K.Types.getTypeColor(for: currentPokemon.types[0].type.name.lowercased())
                secondColor = firstColor
            case 2:
                firstColor = K.Types.getTypeColor(for: currentPokemon.types[0].type.name.lowercased())
                secondColor = K.Types.getTypeColor(for: currentPokemon.types[1].type.name.lowercased())
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            [weak self] in
            self?.viewController?.title = self?.getPokemonTitle()
            self?.viewController?.navigationController?.navigationBar.barTintColor = UIColor.blend(color1: firstColor, color2: secondColor)
            
            self?.getPokemonSprite()
            
            self?.viewController?.tableView.reloadData()
            
            self?.viewController?.didFinishLoading()
        }
    }
    
    func getPokemonTitle() -> String {
        guard let currentPokemon = currentPokemon else { return "" }
        return currentPokemon.name.capitalized
    }
    
    func getPokemonSprite(orientation : PokemonPosition = .front, color : PokemonColor = .normal){
        guard let sprites = currentPokemon?.sprites else { return }
        
        let imageURL : String?
        
        switch (orientation, color) {
        case (PokemonPosition.front, PokemonColor.normal):
            imageURL = sprites.front_default
        case (PokemonPosition.back, PokemonColor.normal):
            imageURL = sprites.back_default
        case (PokemonPosition.front, PokemonColor.shiny):
            imageURL = sprites.front_shiny
        case (PokemonPosition.back, PokemonColor.shiny):
            imageURL = sprites.back_shiny
        }
        
        requestManager.makeRequest(with: imageURL, type: .image)
    }
}

//MARK: - RequestManagerDelegate Methods

extension PokemonDataSource : RequestManagerDelegate {
    func didReceiveData(_ requestManager: RequestManager, data: Data, type requestType : RequestType) {
        fetchingMore = false
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            switch requestType {
            case .json:
                self?.currentPokemon = Pokemon(with: data)
                self?.loadData()
                
            case .image:
                self?.viewController?.didUpdateSprite(with: UIImage(data: data))
            }
        }
    }
    
    func didFailWithError(_ requestManager: RequestManager, error: Error, type requestType : RequestType) {
        fetchingMore = false
        DispatchQueue.main.async {
            [weak self] in
            let errorMessage : String
            switch error {
            case RequestError.json:
                errorMessage = error.localizedDescription
            case RequestError.image:
                errorMessage = "The requested sprite could not found."
            default:
                errorMessage = error.localizedDescription
            }
            
            let ac = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            ac.addAction(okAction)
            self?.viewController?.present(ac, animated: true)
        }
    }
}
