//
//  ProductListVC.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit

class ProductListVC: UIViewController {
    // geting Details
    var productList = [Products]()
    
    var selectedArr =  [Products]()
    
    @IBOutlet weak var cartListTbl: UITableView!
        
    override func viewDidLoad() {

        super.viewDidLoad()
        cartListTbl.delegate = self
        cartListTbl.dataSource = self
        cartListTbl.register(ProductListCell.nibName, forCellReuseIdentifier: ProductListCell.identifier)
        self.callList()
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        self.view.setScreenCaptureProtection()

    }

    @objc func didTakeScreenshot(notification:Notification) -> Void {
    print("Screen Shot Taken")
        let alert = UIAlertController(title: "Screen Capture", message: "This page not allowed to take Screen Shot", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callList(){
        ProductViewModel().getProductList { sucess, productList in
            if sucess {
                print(productList)
               // guard let product = productList else {return}
                self.productList = productList
                DispatchQueue.main.async {
                    self.cartListTbl.reloadData()
                }
            }else{
               print("Negative Responce")
            }
        }
    }
    
    @IBAction func cartAction(_ sender: Any) {
        let vc  = CartVC().getInstance(product: self.selectedArr)
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedArr = self.selectedArr
        self.present(vc, animated: true)
    }
    
}

extension ProductListVC :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as! ProductListCell
        cell.configureFunction(product: self.productList[indexPath.row], index: indexPath)
        cell.delegate = self
        return cell
    }
}
extension ProductListVC:ProductListCellDelegate {
    func addCardBtnClicked(index: IndexPath) {
        print("Index\(index.row)")
        self.selectedArr.append(productList[index.row])
    }
}

