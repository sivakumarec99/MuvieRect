//
//  ProductViewModel.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import Foundation


class ProductViewModel {
    
    func getProductList(completion:@escaping (Bool,[Products]) -> ()){
        
        let url = URL(string: Constant.API.productURL)
        
        let urlRequest = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { dataV, responce, error in
            if error != nil {
                print( error as Any)
            }else{
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(ProductModel.self, from: dataV!)
                    completion(true, responseModel.products ?? [])
                }catch {
                    print("Local Error \(error.localizedDescription)")
                    completion(false,[])
                }
            }
        }
        task.resume()
    }
}
