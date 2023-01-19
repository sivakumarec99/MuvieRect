//
//  ProductListCell.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit

protocol ProductListCellDelegate{
    func addCardBtnClicked(index:IndexPath)
}

class ProductListCell: UITableViewCell {

    static let identifier  = "ProductListCell"
    static let nibName  = UINib(nibName:"ProductListCell" , bundle: nil)
    
    var indePath = IndexPath()
    var delegate  : ProductListCellDelegate? = nil

    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var addBtn:UIButton!
    
    @IBOutlet weak var increasedCountLbl:UILabel!
    @IBOutlet weak var steper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        self.view.layer.cornerRadius = 8
        self.view.layer.masksToBounds = true
        self.view.layer.masksToBounds = false
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowRadius = 4
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    func configureFunction(product:Products,index:IndexPath){
        self.indePath = index
        DispatchQueue.main.async {
            self.imageBox.downloaded(from: product.images?.first ?? "")
        }
        self.titleLbl.text = product.title
        self.priceLbl.text = "\(product.price ?? 0)"
    }
    
    @IBAction func addCartBtnAction(_ sender: Any) {
        self.delegate?.addCardBtnClicked(index: indePath)
    }
    
    
}
