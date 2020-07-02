//
//  PokemonNameSearchBarDelegate.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/30/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonNameSearchBarDelegate: NSObject, UISearchBarDelegate {
    weak var pokemonNameDataSource : PokemonNameDataSource?
    
    func configure(dataSource : PokemonNameDataSource) {
        self.pokemonNameDataSource = dataSource
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            self?.pokemonNameDataSource?.getNames(for: .remaining)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            pokemonNameDataSource?.endFilter()
        }
        else {
            pokemonNameDataSource?.startFilter(with: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        pokemonNameDataSource?.startFilter(with: searchText)
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pokemonNameDataSource?.endFilter()
        searchBar.text = nil
        searchBar.endEditing(true)
    }
}
