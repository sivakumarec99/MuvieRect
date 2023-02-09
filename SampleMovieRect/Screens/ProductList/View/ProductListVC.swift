//
//  ProductListVC.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit
import PDFKit
import AVKit
class ProductListVC: UIViewController {
    // geting Details
    var productList = [Products]()
    
    var selectedArr =  [Products]()
    
    var totalItems = Int()
    
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
        ProductViewModel().getProductList(limit:self.productList.count + 10 , completion: { sucess, productList,count in
            if sucess {
                print(productList)
               // guard let product = productList else {return}
                self.productList = productList
                DispatchQueue.main.async {
                    self.cartListTbl.reloadData()
                }
                self.totalItems = count
            }else{
               print("Negative Responce")
            }
        })
    }
    
    @IBAction func cartAction(_ sender: Any) {
        
        if selectedArr.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Please select at least one product", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

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
        cell.addBtn.clipsToBounds = true
        
        if selectedArr.contains(productList[indexPath.row]){
            cell.addBtn.setTitle("Added", for: .normal)
        }else{
            cell.addBtn.setTitle("Add Cart", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == productList.count - 1 {
            if totalItems > productList.count {
                callList()
            }
        }
        
    }
}
extension ProductListVC:ProductListCellDelegate {
    func addCardBtnClicked(index: IndexPath) {
        print("Index\(index.row)")
        let product = self.productList[index.row]
        if self.selectedArr.contains(product){
            self.selectedArr.removeAll{$0 == product}
        }else{
            self.selectedArr.append(product)
        }
        DispatchQueue.main.async {
            self.cartListTbl.reloadRows(at: [index], with: .none)
        }
        
        
//        let videoURL = URL(string: "https://archive.org/details/SampleVideo1280x7205mb")
//        let player = AVPlayer(url: videoURL!)
//
////        let playerLayer = AVPlayerLayer(player: player)
////        playerLayer.frame = self.view.bounds
////        self.view.layer.addSublayer(playerLayer)
////        player.play()
////
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        
        
        
    }
}

