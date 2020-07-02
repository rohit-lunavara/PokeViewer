//
//  Pokemon.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import Foundation

struct PokemonName : Codable {
    var name : String
    let url : String
}

struct PokemonNameList : Codable {
    let count : Int
    let next : String?
    let previous : String?
    var results : [PokemonName]
    
    init(with data : Data) {
        let jsonDecoder = JSONDecoder()
        guard var pokemonNames = try? jsonDecoder.decode(PokemonNameList.self, from: data) else {
            fatalError("Could not parse Pokemon names from Data.")
        }
        pokemonNames.results = pokemonNames.results.map {
            var pokemonName = $0
            pokemonName.name = pokemonName.name.capitalized
            return pokemonName
        }
        self = pokemonNames
    }
}
