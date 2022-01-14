//
//  BeerTableController.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/1/21.
//

import UIKit
import Foundation

class BeerTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, BeerViewModelDelegate, AlertDisplayer {
    
    @IBOutlet weak var beerListTitle: UILabel!
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var beerTable: UITableView!
    @IBOutlet weak var tableSpinner: UIActivityIndicatorView!
    final let beerCellID = "beerCell"
    private var beerViewModel : BeersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableSpinner.color = .secondaryLabel
        self.view.addSubview(self.tableSpinner)
        self.tableSpinner.autoCenterInSuperview()
        self.tableSpinner.hidesWhenStopped = true
        self.tableSpinner.startAnimating()
        
        self.beerTable.alpha = 0
        self.beerTable.delegate = self
        self.beerTable.dataSource = self
        self.beerTable.prefetchDataSource = self
        self.beerTable.register(BeerTableCellView.self, forCellReuseIdentifier: beerCellID)
        self.beerTable.separatorColor = .lightGray
        
        beerViewModel = BeersViewModel(delegate: self)
        beerViewModel.fetchBeers()
        
        self.view.bringSubviewToFront(self.randomBtn)
        self.randomBtn.layer.cornerRadius = 10
        self.randomBtn.alpha = 0
        self.randomBtn.backgroundColor = .tertiarySystemBackground
        
        self.beerListTitle.alpha = 0
    }
    
    func onFetchFailed(with reason: String) {
        tableSpinner.stopAnimating()
        displayAlert(with: "Loading Failed", message: reason, actions: [UIAlertAction(title: "OK", style: .cancel)])
    }
    
    func onFectchCompleted(with newIndexPathToReload: [IndexPath]?) {
        
        guard let newIndexesToReload = newIndexPathToReload else {
            
            UIView.animate(withDuration: 1) {
                self.tableSpinner.stopAnimating()
                self.beerTable.alpha = 1
                self.randomBtn.alpha = 1
                self.beerListTitle.alpha = 1
                self.beerTable.reloadData()
            }
            return
        }
        
        let indexPathsToReload = visibleIndexPathToReload(intersecting: newIndexesToReload)
        self.beerTable.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    @IBAction func onRandomBtn(_ sender: Any) {
        
        let detailVC = DetailViewController(beer: beerViewModel.randomBeer())
        self.showDetailViewController(detailVC, sender: self)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.beerViewModel.currentCount
    }
    
    func visibleIndexPathToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        
        let visibleRowsIndexPaths = beerTable.indexPathsForVisibleRows ?? []
        let intersectingIndexPaths = Set(visibleRowsIndexPaths).intersection(indexPaths)
        
        return Array(intersectingIndexPaths)
    }
    
    // MARK: - UITableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerViewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let beerCell = tableView.dequeueReusableCell(withIdentifier: beerCellID, for: indexPath) as? BeerTableCellView
        
        if isLoadingCell(for: indexPath) {
            beerCell?.configureCell(with: .none)
        } else {
            beerCell?.configureCell(with: beerViewModel.beer(at: indexPath.row))
        }
        
        return beerCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailViewController(beer: beerViewModel.beer(at: indexPath.row))
        self.showDetailViewController(detailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            beerViewModel.fetchBeers()
            print("prefetching !!!")
        }
    }
}
