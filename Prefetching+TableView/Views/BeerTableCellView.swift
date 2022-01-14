//
//  BeerTableCellView.swift
//  Prefetching+TableView
//
//  Created by Bruce Gomes on 4/1/21.
//

import Foundation

class BeerTableCellView: UITableViewCell {
    
    let imgView = UIImageView(forAutoLayout: ())
    let titleLbl = UILabel(forAutoLayout: ())
    let subTitleLbl = UILabel(forAutoLayout: ())
    let accView = UIView(forAutoLayout: ())
    let abvLbl = UILabel(forAutoLayout: ())
    let cellSpinner = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        imgView.image = UIImage(named: "notFound")
        imgView.contentMode = .scaleAspectFit
        imgView.autoSetDimensions(to: CGSize(width: 70, height: 90))
        self.contentView.addSubview(imgView)
        imgView.autoPinEdge(toSuperviewEdge: .left)
        imgView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        titleLbl.text = "Beer Name Not Found"
        titleLbl.textColor = .label
        titleLbl.numberOfLines = 2
        titleLbl.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(titleLbl)
        //titleLbl.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        titleLbl.autoAlignAxis(.horizontal, toSameAxisOf: titleLbl.superview!, withOffset: -15)
        
        titleLbl.autoPinEdge(.left, to: .right, of: imgView, withOffset: 4)
        titleLbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        subTitleLbl.text = "Beer Tagline"
        subTitleLbl.textColor = .secondaryLabel
        subTitleLbl.numberOfLines = 5
        subTitleLbl.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(subTitleLbl)
        subTitleLbl.autoPinEdge(.left, to: .left, of: titleLbl)
        subTitleLbl.autoPinEdge(.top, to: .bottom, of: titleLbl).priority = .required
       // subTitleLbl.autoPinEdge(toSuperviewEdge: .bottom)
        subTitleLbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.contentView.addSubview(accView)
        accView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .left)
        accView.autoPinEdge(.left, to: .right, of: subTitleLbl)
        accView.autoPinEdge(.left, to: .right, of: titleLbl)
        accView.autoPinEdge(toSuperviewEdge: .top)
        accView.autoPinEdge(toSuperviewEdge: .bottom)
        
        let accImg = UIImageView(image: UIImage(systemName: "info.circle"))
        accImg.autoSetDimensions(to: CGSize(width: 26, height: 26))
        accView.addSubview(accImg)
        accImg.autoAlignAxis(toSuperviewAxis: .horizontal)
        accImg.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        
        abvLbl.text = "0.0%"
        accView.addSubview(abvLbl)
        abvLbl.autoAlignAxis(toSuperviewAxis: .horizontal)
        abvLbl.autoPinEdge(.right, to: .left, of: accImg, withOffset: -4)
        abvLbl.autoPinEdge(toSuperviewEdge: .left)
        abvLbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.contentView.addSubview(cellSpinner)
        cellSpinner.autoCenterInSuperview()
        cellSpinner.hidesWhenStopped = true
    }
    
    func configureCell(with beer : Beer?) {
        
        if let beer = beer {
            
            let img = try? UIImage(data: Data(contentsOf: URL(string: beer.imageUrl)!)) ?? UIImage(named: "notFound")
            imgView.image = img
            titleLbl.text = beer.name
            subTitleLbl.text = beer.tagline
            abvLbl.text = String(beer.abv)
            
            cellSpinner.stopAnimating()
            titleLbl.isHidden = false
            subTitleLbl.isHidden = false
            imgView.isHidden = false
            accView.isHidden = false
        } else {
            titleLbl.isHidden = true
            subTitleLbl.isHidden = true
            imgView.isHidden = true
            accView.isHidden = true
            cellSpinner.startAnimating()
        }
    }
}
