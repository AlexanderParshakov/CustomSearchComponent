//
//  NetworkManager.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 19.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static private let apiURL = "http://iswiftdata.1c-work.net/api/products/searchproductsbycategory"
    
    // headers
    static private let accessKey = "test_05fc5ed1-0199-4259-92a0-2cd58214b29c"
    static private let idCategory = ""
    static private let idClient = ""
    static private let pageNumberIncome = 1
    static private let pageSizeIncome = 12
    
    static private let headers = [
        "AccessKey": accessKey,
        "IDCategory": idCategory,
        "IDClient": idClient,
        "pageNumberIncome": String(pageNumberIncome),
        "pageSizeIncome": String(pageSizeIncome)
    ]
    
    static func getNumberOfItems(parameters: [String:String], completion: @escaping (Result<[String: Any]>) -> Void) {
        
        Alamofire.request(apiURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let data as [String: Any]):
                completion(.success(data))

            case .failure(let error):
                completion(.failure(error))

            default:
                fatalError("received non-dictionary JSON response")
            }
        }
    }
}
