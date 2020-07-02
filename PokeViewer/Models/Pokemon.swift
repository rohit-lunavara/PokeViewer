//
//  Pokemon.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import Foundation

struct Pokemon : Codable {
    let id : Int
    var name : String
    var abilities : [Abilities]
    let sprites : Sprites
    var stats : [Stats]
    var types : [Types]
    
    init(with data : Data) {
        let jsonDecoder = JSONDecoder()
        guard var pokemonNames = try? jsonDecoder.decode(Pokemon.self, from: data) else {
            fatalError("Could not parse Pokemon from Data.")
        }
        pokemonNames.name = pokemonNames.name.capitalized
        pokemonNames.abilities = pokemonNames.abilities.map {
            var abilities = $0
            abilities.ability.name = abilities.ability.name.capitalized
            return abilities
        }
        pokemonNames.stats = pokemonNames.stats.map {
            var stats = $0
            stats.stat.name = stats.stat.name.capitalized
            return stats
        }
        pokemonNames.types = pokemonNames.types.map {
            var types = $0
            types.type.name = types.type.name.capitalized
            return types
        }
        self = pokemonNames
    }
}

struct Abilities : Codable {
    var ability : Ability
    let is_hidden : Bool
}

struct Ability : Codable {
    var name : String
    let url : String
}

struct Sprites : Codable {
    let back_default : String?
    let back_shiny : String?
    let front_default : String?
    let front_shiny : String?
}

struct Stats : Codable {
    let base_stat : Int
    let effort : Int
    var stat : Stat
}

struct Stat : Codable {
    var name : String
    let url : String
}

struct Types : Codable {
    let slot : Int
    var type : Type
}

struct Type : Codable {
    var name : String
    let url : String
}
