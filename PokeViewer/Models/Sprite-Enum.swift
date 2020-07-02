//
//  Sprite-Enum.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/29/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import Foundation

enum PokemonPosition {
    case front
    case back
    
    mutating func toggle() {
        switch self {
        case .front:
            self = .back
        case .back:
            self = .front
        }
    }
    
    var name : String {
        switch self {
        case .front:
            return "Front"
        case .back:
            return "Back"
        }
    }
    
    var oppositeName : String {
        switch self {
        case .front:
            return "Back"
        case .back:
            return "Front"
        }
    }
}

enum PokemonColor {
    case normal
    case shiny
    
    mutating func toggle() {
        switch self {
        case .normal:
            self = .shiny
        case .shiny:
            self = .normal
        }
    }
    
    var name : String {
        switch self {
        case .normal:
            return "Normal"
        case .shiny:
            return "Shiny"
        }
    }
    
    var oppositeName : String {
        switch self {
        case .normal:
            return "Shiny"
        case .shiny:
            return "Normal"
        }
    }
}
