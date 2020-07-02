//
//  PokemonNameDataSource.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonNameDataSource : NSObject, UITableViewDataSource {
    weak var viewController : PokemonMasterViewController?
    let requestManager = RequestManager()
    
    var currentPokemonList : PokemonNameList?
    var pokemonNames = [PokemonName]()
    var filteredPokemonNames = [PokemonName]()
    var isFiltered = false
    var fetchingMore = false
    
    func configure(viewController : PokemonMasterViewController) {
        self.viewController = viewController
        requestManager.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 where !isFiltered:
            return pokemonNames.count
        case 0 where isFiltered:
            return filteredPokemonNames.count
            
        case 1 where fetchingMore:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPokemonNames = !isFiltered ? pokemonNames : filteredPokemonNames
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.PokeCell, for: indexPath)
            
            let pokemonName = currentPokemonNames[indexPath.row]
            cell.textLabel?.text = pokemonName.name
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.LoadingCell, for: indexPath) as! LoadingCell
            
            cell.spinner.startAnimating()
            
            return cell
        }
    }
    
    func getItem(at index : Int) -> PokemonName {
        return !isFiltered ? pokemonNames[index] : filteredPokemonNames[index]
    }
}

//MARK: - Fetch and Load Data

extension PokemonNameDataSource {
    func getRemainingURL(for url : String?) -> String? {
        let newURL = url?.replacingOccurrences(of: K.URL.defaultLimit, with: K.URL.upperLimit)
        return newURL
    }
    
    func getNames(for request : PokemonNameRequest) {
        guard fetchingMore == false else { return }
        
        let urlString : String?
        switch request {
        case .first:
            urlString = K.PokemonName.firstURLString
        case .next:
            urlString = currentPokemonList?.next
        case .remaining:
            urlString = getRemainingURL(for: currentPokemonList?.next)
        }
        
        guard let url = urlString else { return }
        fetchingMore = true
        requestManager.makeRequest(with: url, type: .json)
    }
    
    func startFilter(with text : String) {
        filteredPokemonNames = pokemonNames.filter { (pokemonName) -> Bool in
            pokemonName.name.localizedCaseInsensitiveContains(text)
        }
        isFiltered = true
        
        DispatchQueue.main.async {
            [weak self] in
            self?.viewController?.tableView.reloadData()
        }
    }
    
    func endFilter() {
        isFiltered = false
        filteredPokemonNames.removeAll(keepingCapacity: true)
        
        DispatchQueue.main.async {
            [weak self] in
            self?.viewController?.tableView.reloadData()
        }
    }
}

//MARK: - RequestManagerDelegate Methods

extension PokemonNameDataSource : RequestManagerDelegate {
    
    func didReceiveData(_ requestManager: RequestManager, data: Data, type requestType : RequestType) {
        fetchingMore = false
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            switch requestType {
            case .json:
                self?.currentPokemonList = PokemonNameList(with: data)
                guard let newPokemonList = self?.currentPokemonList else {
                    fatalError("Could not parse new Pokemon list.")
                }
                self?.pokemonNames.append(contentsOf: newPokemonList.results)
                DispatchQueue.main.async {
                    self?.viewController?.tableView.reloadData()
                }
                
            case .image:
                break
            }
        }
    }
    
    func didFailWithError(_ requestManager: RequestManager, error: Error, type requestType : RequestType) {
        fetchingMore = false
        DispatchQueue.main.async {
            [weak self] in
            let errorMessage : String
            switch error {
            case RequestError.json, RequestError.image:
                errorMessage = error.localizedDescription
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
