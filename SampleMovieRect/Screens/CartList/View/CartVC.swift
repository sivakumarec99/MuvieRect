//
//  CartVC.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import UIKit
import PDFKit
import PDFReader

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
        cartListTbl.register(CartListCell.nibName, forCellReuseIdentifier: CartListCell.identifier)
        self.totalAmountMony()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func totalAmountMony(){
        let amountArr =  selectedArr.map{($0.price ?? 0) * ($0.qty ?? 1)}
        let total  = amountArr.reduce(into: 0) { partialResult, value in
            partialResult += value
        }
        self.totalAmount = "\(total)"
    }
    
    func getInstance(product:[Products]) -> CartVC{
        let storyBoard =  UIStoryboard.init(name:"CartVC" , bundle: nil)
        let vc =  storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        return vc
    }
    
    
    @IBAction func viewInvoiceAction(){
        
        //self.dismiss(animated: true)
//       let dataPdf =  self.createFlyer()
//
//        if let data = documentData {
//          pdfView.document = PDFDocument(data: dataPdf)
//          pdfView.autoScales = true
//        }
//
//        guard let vc = segue.destination as? PDFPreviewViewController else { return }
//        let pdfCreator = PDFCreator()
//        vc.documentData = pdfCreator.createFlyer()

        if selectedArr.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Please select at least one product", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
//      MARK: ***Sample Two -> Working  But wee need to desing like a html
        
        self.createPDF()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent("file").appendingPathExtension("pdf")
       // let urlRequest = URLRequest(url: url)
        let VC = WebVC().getInstance()
        VC.urlString = url.absoluteString
        self.present(VC, animated: true) {
        }
        
        
        //      MARK: ***Sample Three ->Full Table Can Be Printed

//
//        self.createPdfFromTableView()
//
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent("file").appendingPathExtension("pdf")
//        // let urlRequest = URLRequest(url: url)
//        let VC = WebVC().getInstance()
//        VC.urlString = url.absoluteString
//        self.present(VC, animated: true) {
//
//        }
                
        
        //      MARK: ***Sample Four ->Full Table Can Be Printed
    
//        let fileData = self.cartListTbl.convertToPDF()!
//
//        let document = PDFDocument(fileData: fileData, fileName: "Sample PDF")!
//
//        let readerController = PDFViewController.createNew(with: document)
//        self.navigationController?.pushViewController(readerController, animated: true)
        
    }
    
//    func createPdfFromTableView()
//    {
//        let priorBounds: CGRect = self.cartListTbl.bounds
//        let fittedSize: CGSize = self.cartListTbl.sizeThatFits(CGSize(width: priorBounds.size.width, height: self.cartListTbl.contentSize.height))
//        self.cartListTbl.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
//        self.cartListTbl.reloadData()
//        let pdfPageBounds: CGRect = CGRect(x: 0, y: 0, width: fittedSize.width, height: (fittedSize.height))
//        let pdfData: NSMutableData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
//        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
//        self.cartListTbl.layer.render(in: UIGraphicsGetCurrentContext()!)
//        UIGraphicsEndPDFContext()
//        let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//        //let documentsFileName = documentDirectories! + "/" + "pdfName"
//        pdfData.write(toFile: "\(documentDirectories ?? "123")/file.pdf", atomically: true)
//    }
    
    func createPDF() {
            
        var  listDocumetArr = [String]()
        self.selectedArr.forEach { product in
            listDocumetArr.append("<tr><td>\(product.title ?? "")</td> <td>\(product.price ?? 0)</td> <td>\(product.qty ?? 1)</td> <td>\(product.price ?? 0)</td></tr>")
        }

       let detailsStrt = listDocumetArr.joined()
        
       let table =  "<table style='width:100%'> <tr> <th>Name</th> <th>Price</th> <th>Qty</th> <th>Amount</th> </tr> \(detailsStrt) </table>"
        
        let style = "<style>td {text-align: center;} table, th, td {border:1px solid black;} </style>"

        let html = "\(style)<b>Order <i>Details</i></b> \(table)<p> TotalAmount:\(totalAmount)</p>"
        
        
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        pdfData.write(toFile: "\(documentsPath)/file.pdf", atomically: true)
    }



    func createFlyer() -> Data {
      // 1
      let pdfMetaData = [
        kCGPDFContextCreator: "Flyer Builder",
        kCGPDFContextAuthor: "raywenderlich.com"
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]

      // 2
      let pageWidth = 8.5 * 72.0
      let pageHeight = 11 * 72.0
      let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
  
      // 3
      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      // 4
      let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        let attributes = [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
        ]
        let text = "I'm a PDF!"
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
      }

      return data
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CartListCell.identifier) as! CartListCell
        cell.configureFunction(product: self.selectedArr[indexPath.row], index: indexPath)
        cell.delegate = self
        return cell
    }
}

extension CartVC: CartListCellDelegate {
    func stepperBtnClicked(Index: IndexPath, value: Int) {
        var product = self.selectedArr[Index.row]
        product.qty = value
        self.selectedArr[Index.row] = product
        DispatchQueue.main.async {
            self.cartListTbl.reloadRows(at: [Index], with: .none)
            self.totalAmountMony()
        }
    }
    
    func delteButunClicked(Index: IndexPath) {
        selectedArr.remove(at: Index.row)
        DispatchQueue.main.async {
            self.cartListTbl.reloadData()
            self.totalAmountMony()
        }
    }
}

extension UITableView {
    func convertToPDF() -> Data? {
        let priorBounds = self.bounds
        setBoundsForAllItems()
        self.layoutIfNeeded()
        let pdfData = createPDF()
        self.bounds = priorBounds
        return pdfData.copy() as? Data
    }

    private func getContentFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
    }

    private func createPDF() -> NSMutableData {
        let pdfPageBounds: CGRect = getContentFrame()
        let pdfData: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()
        return pdfData
    }

    private func setBoundsForAllItems() {
        if self.isEndOfTheScroll() {
            self.bounds = getContentFrame()
        } else {
            self.bounds = getContentFrame()
            self.reloadData()
        }
    }

    private func isEndOfTheScroll() -> Bool  {
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        return distanceFromBottom < frame.size.height
    }
}
