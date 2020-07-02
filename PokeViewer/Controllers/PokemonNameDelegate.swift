//
//  PokemonNameDelegate.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

final class PokemonNameDelegate: NSObject, UITableViewDelegate {
    weak var viewController : PokemonMasterViewController?
    
    func configure(viewController : PokemonMasterViewController) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pokeDetailVC = viewController?.storyboard?.instantiateViewController(identifier: K.VC.PokemonDetailViewController) as? PokemonDetailViewController else {
            fatalError("Could not load PokeDetailViewController.")
        }
        
        pokeDetailVC.pokemonDataSource.pokemonName = viewController?.pokemonNameDataSource.getItem(at : indexPath.row)
        viewController?.navigationController?.pushViewController(pokeDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            viewController?.scrollViewDidReachEnd()
        }
    }
}

