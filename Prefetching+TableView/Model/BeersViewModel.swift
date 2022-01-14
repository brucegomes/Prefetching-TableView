//
//  BeersViewModel.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/1/21.
//

import Foundation

protocol BeerViewModelDelegate : AnyObject {
    
    func onFetchFailed(with reason: String)
    func onFectchCompleted(with newIndexPathToReload: [IndexPath]?)
}

final class BeersViewModel {
    
    private weak var delegate : BeerViewModelDelegate?
    private var beers: [Beer] = []
    private var curPage = 1
    private var totalBeers = 0
    private var isFetchingInProgress = false
    private let itensPerPage = 25
    
    let client = PunkClient()
    
    init(delegate: BeerViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount : Int {
        return beers.count
    }
    
    var totalCount: Int {
        return totalBeers
    }
    
    func beer(at index : Int) -> Beer {
        return beers[index]
    }
    
    func randomBeer() -> Beer {
        return beers.randomElement() ?? beers[0]
    }
    
    func fetchBeers() {
        
        guard !isFetchingInProgress else {
            return
        }
        isFetchingInProgress = true
        
        client.fetchBeers(page: curPage) { (result) in
            
            switch result {
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchingInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    self.curPage += 1
                    self.isFetchingInProgress = false
                    self.totalBeers = 150//response.count
                    self.beers.append(contentsOf: response)
                    
                    let isOverFirstPage = ((response.last?.id ?? 0) / self.itensPerPage) > 1
                    
                    if isOverFirstPage {
                        let indexPathToReload = self.calculateNexIndexPathToReload(from: response)
                        self.delegate?.onFectchCompleted(with: indexPathToReload)
                    } else {
                        self.delegate?.onFectchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    func calculateNexIndexPathToReload(from newBeers: [Beer]) -> [IndexPath] {
        
        let startIndex = beers.count - newBeers.count
        let endIndex = startIndex + newBeers.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
