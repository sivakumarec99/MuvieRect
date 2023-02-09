//
//  CartListCell.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 20/01/23.
//

import UIKit

protocol CartListCellDelegate{
    func delteButunClicked(Index:IndexPath)
    func stepperBtnClicked(Index:IndexPath,value:Int)
    
}
class CartListCell: UITableViewCell {

    static let identifier  = "CartListCell"
    static let nibName  = UINib(nibName:"CartListCell" , bundle: nil)
    
    var indePath = IndexPath()
    var delegate  : CartListCellDelegate? = nil

    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var steper: UIStepper!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var stepCountLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFunction(product:Products,index:IndexPath){
        self.indePath = index
        DispatchQueue.main.async {
            self.imageBox.downloaded(from: product.images?.first ?? "")
        }
        self.titleLbl.text = product.title
        self.priceLbl.text = "$ \(product.price ?? 0)"
        self.stepCountLbl.text = "\(product.qty ?? 1)"
        self.steper.value = Double(product.qty ?? 1)
        self.steper.wraps = false
        self.steper.autorepeat = true
    }
    
    
    @IBAction func deletAction(_ sender: Any) {
        self.delegate?.delteButunClicked(Index: indePath)
    }
    
//    @IBAction func stepperAction(_ sender: UIStepper) {
//        self.delegate?.stepperBtnClicked(Index: indePath, value: "\(sender.value)")
//    }
//
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        print(sender.value)
        self.delegate?.stepperBtnClicked(Index: indePath, value: Int(sender.value))
    }
    
}
