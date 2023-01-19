//
//  ViewController.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        let storyBoard =  UIStoryboard.init(name:"ProductListVC" , bundle: nil)
        let vc =  storyBoard.instantiateViewController(withIdentifier: "ProductListVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
     


}

