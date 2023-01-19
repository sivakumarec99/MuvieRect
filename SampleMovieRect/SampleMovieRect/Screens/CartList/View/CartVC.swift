//
//  CartVC.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit

class CartVC: UIViewController {
    
    var selectedArr =  [Products]()

    @IBOutlet weak var cartListTbl: UITableView!

    @IBOutlet weak var totalAmountLbl:UILabel!
    
    var totalAmount:String = "" {
        didSet{
            totalAmountLbl.text = "Total Amount : \(totalAmount)"
            totalAmountLbl.textColor = .white
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartListTbl.delegate = self
        cartListTbl.dataSource = self
        cartListTbl.register(ProductListCell.nibName, forCellReuseIdentifier: ProductListCell.identifier)

        let amountArr =  selectedArr.map{$0.price}
        let total  = amountArr.reduce(into: 0) { partialResult, value in
            partialResult += value ?? 0
        }
        self.totalAmount = "\(total)"

    }
    
    func getInstance(product:[Products]) -> CartVC{
        let storyBoard =  UIStoryboard.init(name:"CartVC" , bundle: nil)
        let vc =  storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        return vc
    }
    
    
    @IBAction func viewInvoiceAction(){
        
        self.dismiss(animated: true)
        
        

    }

}

extension CartVC :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as! ProductListCell
        cell.configureFunction(product: self.selectedArr[indexPath.row], index: indexPath)
        cell.addBtn.isHidden = true
        return cell
    }
}
