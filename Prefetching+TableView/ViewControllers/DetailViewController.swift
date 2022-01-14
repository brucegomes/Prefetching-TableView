//
//  DetailViewController.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/3/21.
//

import Foundation

//
//  DetailViewController.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/3/21.
//

import Foundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var beerTitle = UILabel(forAutoLayout: ())
    var imgView = UIImageView(forAutoLayout: ())
    var beerTagline = UILabel(forAutoLayout: ())
    var beerDescription = UILabel(forAutoLayout: ())
    var detailTable = UITableView(frame: .zero, style: .insetGrouped)
    
    let cellId = "detailCellId"
    
    let beer : Beer!
    
    init(beer :Beer) {
        self.beer = beer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.beerTitle.text = beer.name
        self.beerTitle.textColor = .label
        self.beerTitle.textAlignment = .center
        self.beerTitle.font = .systemFont(ofSize: 20)
        self.view.addSubview(beerTitle)
        self.beerTitle.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), excludingEdge: .bottom)
        
        self.beerTagline.text = beer.tagline
        self.beerTagline.textColor = .secondaryLabel
        self.beerTagline.textAlignment = .center
        self.beerTagline.font = .systemFont(ofSize: 15)
        self.view.addSubview(beerTagline)
        self.beerTagline.autoPinEdge(.top, to: .bottom, of: beerTitle, withOffset: 4)
        self.beerTagline.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        self.beerTagline.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        self.beerTagline.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let img = try? UIImage(data: Data(contentsOf: URL(string: beer.imageUrl)!)) ?? UIImage(named: "notFound")
        imgView.image = img
        self.view.addSubview(imgView)
        imgView.autoPinEdge(.top, to: .bottom, of: beerTagline, withOffset: 8)
        imgView.autoAlignAxis(toSuperviewAxis: .vertical)
        imgView.autoSetDimensions(to: CGSize(width: 50, height: 150))
        
        self.beerDescription.text = beer.description
        self.beerDescription.numberOfLines = 0
        self.beerDescription.lineBreakMode = .byCharWrapping
        self.beerDescription.font = .systemFont(ofSize: 12)
        self.view.addSubview(self.beerDescription)
        self.beerDescription.autoPinEdge(.top, to: .bottom, of: imgView, withOffset: 8)
        self.beerDescription.autoPinEdge(toSuperviewEdge: .leading, withInset: 8)
        self.beerDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)
        
        self.detailTable.delegate = self
        self.detailTable.dataSource = self
        self.detailTable.allowsSelection = false
        self.view.addSubview(detailTable)
        self.detailTable.autoPinEdge(.top, to: .bottom, of: beerDescription, withOffset: 8)
        self.detailTable.autoPinEdge(toSuperviewEdge: .leading)
        self.detailTable.autoPinEdge(toSuperviewEdge: .trailing)
        self.detailTable.autoPinEdge(toSuperviewSafeArea: .bottom)
    }
    
    // MARK: - UITableview methods
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Ingredient: MALT"
        case 2:
            return "Ingredient: HOPS"
        case 3:
            return "Ingredient: YEAST"
            
        default:
            print("no title")
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            // num of ingredient itens rows plus divisory rows
            return (beer.ingredients.malt.count * 2) + (beer.ingredients.malt.count - 1)
        } else if section == 2 {
            return (beer.ingredients.hops.count * 2) + (beer.ingredients.hops.count - 1)
        } else if section == 3 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil { // true because we didn't register it, on purpose so we could customize the cell
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        cell?.separatorInset = .zero
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Alcohol Content(abv)"
                cell?.detailTextLabel?.text = String(beer.abv)
            case 1:
                cell?.textLabel?.text = "First brew"
                cell?.detailTextLabel?.text = String(beer.firstBrewed)
            case 2:
                cell?.textLabel?.text = "Bitterness Value(ibu)"
                cell?.detailTextLabel?.text = String(beer.ibu ?? 0)
            //case 3:
            default:
                print("no value found for cell: \(indexPath.row)")
            }
            
        } else if indexPath.section == 1 {
            if (indexPath.row + 1) % 3 == 1 {
                cell?.textLabel?.text = "Name"
                cell?.detailTextLabel?.text = beer.ingredients.malt[indexPath.row / 3].name
            } else if (indexPath.row + 1) % 3 == 2 {
                cell?.textLabel?.text = "Amount"
                cell?.detailTextLabel?.text = "\(beer.ingredients.malt[(indexPath.row - 1) / 3].amount.value) \(beer.ingredients.malt[(indexPath.row - 1) / 3].amount.unit)"
            } else if (indexPath.row + 1) % 3 == 0 {
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = " "
            }
            
        }  else if indexPath.section == 2 {
            if (indexPath.row + 1) % 5 == 1 {
                cell?.textLabel?.text = "Name"
                cell?.detailTextLabel?.text = beer.ingredients.hops[indexPath.row / 3].name
            } else if (indexPath.row + 1) % 5 == 2 {
                cell?.textLabel?.text = "Amount"
                cell?.detailTextLabel?.text = "\(beer.ingredients.hops[(indexPath.row - 1) / 5].amount.value) \(beer.ingredients.hops[(indexPath.row - 1) / 5].amount.unit)"
            } else if (indexPath.row + 1) % 5 == 3 {
                cell?.textLabel?.text = "add"
                cell?.detailTextLabel?.text = beer.ingredients.hops[(indexPath.row - 2) / 5].add
            } else if (indexPath.row + 1) % 5 == 4 {
                cell?.textLabel?.text = "attribute"
                cell?.detailTextLabel?.text = beer.ingredients.hops[(indexPath.row - 3) / 5].attribute
            }
            else if (indexPath.row + 1) % 5 == 0 {
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = " "
            }
        } else if indexPath.section == 3 {
            cell?.textLabel?.text = "Yeast"
            cell?.detailTextLabel?.text = beer.ingredients.yeast
        }
        
        return cell!
    }
}

// This is how I calculated the pattern to map indexPaths to the Beer Model arrays
//0 e 1 = 0
//3 e 4 = 1
//6 e 7 = 2
//x   y   z
//
//y = x + 1
//x - 2z = z
//y - (2z+1) = z
