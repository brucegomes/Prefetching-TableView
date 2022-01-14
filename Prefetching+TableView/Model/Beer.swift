//
//  Beer.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/1/21.
//

import Foundation

struct Beer: Decodable {
    
    let id : Int
    let name : String
    let tagline : String
    let firstBrewed : String
    let description : String
    let abv : Float16
    let ibu : Float16?
    let imageUrl : String
    let ingredients : BeerIngredientsCategory
    
    struct BeerIngredientsCategory : Decodable {
        let malt : [BeerIngredient]
        let hops : [BeerIngredient]
        let yeast : String
    }
    
    struct BeerIngredient : Decodable {
        let name : String
        let amount : IngredientAmnt
        let add : String?
        let attribute : String?
    }
    
    struct IngredientAmnt : Decodable {
        let value : Float16
        let unit : String
    }
}
