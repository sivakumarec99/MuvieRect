//
//  WebVC.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 20/01/23.
//

import UIKit
import WebKit

class WebVC: UIViewController{

    var webView: WKWebView!
    var urlString = String()
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        webView.alpha = 1
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
    
    func getInstance() -> WebVC {
        let storyBoard =  UIStoryboard.init(name:"WebVC" , bundle: nil)
        let vc =  storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        return vc
    }
    
    
    fileprivate func prepareHTML() -> String? {
        return urlString
    }
    
    func createPDF(formmatter: UIViewPrintFormatter, filename: String) -> String {
         // From: https://gist.github.com/nyg/b8cd742250826cb1471f

         // 2. Assign print formatter to UIPrintPageRenderer
         let render = UIPrintPageRenderer()
         render.addPrintFormatter(formmatter, startingAtPageAt: 0)

         // 3. Assign paperRect and printableRect
         let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
         let printable = page.insetBy(dx: 0, dy: 0)

         render.setValue(NSValue(cgRect: page), forKey: "paperRect")
         render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

         // 4. Create PDF context and draw
         let pdfData = NSMutableData()
         UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

         for i in 1...render.numberOfPages {

             UIGraphicsBeginPDFPage();
             let bounds = UIGraphicsGetPDFContextBounds()
             render.drawPage(at: i - 1, in: bounds)
         }

         UIGraphicsEndPDFContext();

         // 5. Save PDF file
         let path = "\(NSTemporaryDirectory())\(filename).pdf"
         pdfData.write(toFile: path, atomically: true)
         print("open \(path)")

         return path
     }
}

extension WebVC: WKNavigationDelegate,WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let path = createPDF(formmatter: webView.viewPrintFormatter(), filename: "MyPDFDocument")
        print("PDF location: \(path)")
        
        let fileManager = FileManager.default
        let documentoPath = path
        if fileManager.fileExists(atPath: documentoPath){
             let documento = NSData(contentsOfFile: documentoPath)
             let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView=self.view
             present(activityViewController, animated: true, completion: nil)
         }
         else {
             print("document was not found")
         }
    }
}
