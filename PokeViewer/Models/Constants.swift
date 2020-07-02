//
//  Constants.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/29/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

struct K {
    static let appName = "PokeViewer"
    
    struct PokemonName {
        static let firstURLString = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=100"
        static let allURLString = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=100000"
    }
    
    struct VC {
        static let PokemonDetailViewController = "PokemonDetailViewController"
    }
    
    struct URL {
        static let defaultLimit = "limit=100"
        static let upperLimit = "limit=100000"
    }
    
    struct Ability {
        static let hidden = UIImage(systemName: "eye.slash.fill")!
        static let normal = UIImage(systemName: "eye.fill")!
    }
    
    struct Cell {
        static let PokeCell = "PokeCell"
        static let LoadingCell = "LoadingCell"
        static let DetailCell = "DetailCell"
        static let AbilityDetailCell = "AbilityDetailCell"
        static let StatDetailCell = "StatDetailCell"
    }
    
    struct Buttons {
        static let backgroundColor = UIColor.systemBlue
        static let borderColor = UIColor.systemBlue
        static let textColor = UIColor.darkText
    }
    
    struct Types {
        // Credits : https://bulbapedia.bulbagarden.net/wiki/Category:Type_color_templates
        // Medium
        //        static let bug = UIColor(red: 0.66, green: 0.72, blue: 0.13, alpha: 1.00)
        //        static let dark = UIColor(red: 0.44, green: 0.35, blue: 0.28, alpha: 1.00)
        //        static let dragon = UIColor(red: 0.44, green: 0.22, blue: 0.97, alpha: 1.00)
        //        static let electric = UIColor(red: 0.97, green: 0.82, blue: 0.19, alpha: 1.00)
        //        static let fairy = UIColor(red: 0.93, green: 0.60, blue: 0.67, alpha: 1.00)
        //        static let fighting = UIColor(red: 0.75, green: 0.19, blue: 0.16, alpha: 1.00)
        //        static let fire = UIColor(red: 0.94, green: 0.50, blue: 0.19, alpha: 1.00)
        //        static let flying = UIColor(red: 0.66, green: 0.56, blue: 0.94, alpha: 1.00)
        //        static let ghost = UIColor(red: 0.44, green: 0.35, blue: 0.60, alpha: 1.00)
        //        static let grass = UIColor(red: 0.47, green: 0.78, blue: 0.31, alpha: 1.00)
        //        static let ground = UIColor(red: 0.88, green: 0.75, blue: 0.41, alpha: 1.00)
        //        static let ice = UIColor(red: 0.60, green: 0.85, blue: 0.85, alpha: 1.00)
        //        static let normal = UIColor(red: 0.66, green: 0.66, blue: 0.47, alpha: 1.00)
        //        static let poison = UIColor(red: 0.63, green: 0.25, blue: 0.63, alpha: 1.00)
        //        static let psychic = UIColor(red: 0.97, green: 0.35, blue: 0.53, alpha: 1.00)
        //        static let rock = UIColor(red: 0.72, green: 0.63, blue: 0.22, alpha: 1.00)
        //        static let steel = UIColor(red: 0.72, green: 0.72, blue: 0.82, alpha: 1.00)
        //        static let water = UIColor(red: 0.41, green: 0.56, blue: 0.94, alpha: 1.00)
        //        static let unknown = UIColor(red: 0.41, green: 0.63, blue: 0.56, alpha: 1.00)
        
        // Light
        static let bug = UIColor(hexaString: "C6D16E")
        static let dark = UIColor(hexaString: "A29288")
        static let dragon = UIColor(hexaString: "A27DFA")
        static let electric = UIColor(hexaString: "FAE078")
        static let fairy = UIColor(hexaString: "F4BDC9")
        static let fighting = UIColor(hexaString: "D67873")
        static let fire = UIColor(hexaString: "F5AC78")
        static let flying = UIColor(hexaString: "C6B7F5")
        static let ghost = UIColor(hexaString: "A292BC")
        static let grass = UIColor(hexaString: "A7DB8D")
        static let ground = UIColor(hexaString: "EBD69D")
        static let ice = UIColor(hexaString: "BCE6E6")
        static let normal = UIColor(hexaString: "C6C6A7")
        static let poison = UIColor(hexaString: "C183C1")
        static let psychic = UIColor(hexaString: "FA92B2")
        static let rock = UIColor(hexaString: "D1C17D")
        static let steel = UIColor(hexaString: "D1D1E0")
        static let water = UIColor(hexaString: "9DB7F5")
        static let unknown = UIColor(hexaString: "9DC1B7")
        
        static func getTypeColor(for type : String) -> UIColor {
            switch type {
            case "bug":
                return Types.bug
            case "dark":
                return Types.dark
            case "dragon":
                return Types.dragon
            case "electric":
                return Types.electric
            case "fairy":
                return Types.fairy
            case "fighting":
                return Types.fighting
            case "fire":
                return Types.fire
            case "flying":
                return Types.flying
            case "ghost":
                return Types.ghost
            case "grass":
                return Types.grass
            case "ground":
                return Types.ground
            case "ice":
                return Types.ice
            case "normal":
                return Types.normal
            case "poison":
                return Types.poison
            case "psychic":
                return Types.psychic
            case "rock":
                return Types.rock
            case "steel":
                return Types.steel
            case "water":
                return Types.water
            default:
                return Types.unknown
            }
        }
    }
    
    struct Stats {
        static let veryLow = UIColor(hexaString: "e74c3c").withAlphaComponent(0.5)
        static let low = UIColor(hexaString: "e67e22").withAlphaComponent(0.5)
        static let average = UIColor(hexaString: "f1c40f").withAlphaComponent(0.5)
        static let high = UIColor(hexaString: "27ae60").withAlphaComponent(0.5)
        static let veryHigh = UIColor(hexaString: "16a085").withAlphaComponent(0.5)
        static let unknown = UIColor.clear
        
        static func getStatColor(for statValue : Int) -> UIColor {
            switch statValue {
            case Int.min ..< 30:
                return Stats.veryLow
            case 30 ..< 60:
                return Stats.low
            case 60 ..< 90:
                return Stats.average
            case 90 ..< 120:
                return Stats.high
            case 120 ..< Int.max:
                return Stats.veryHigh
            default:
                return Stats.unknown
            }
        }
    }
}
