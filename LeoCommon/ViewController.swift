//
//  ViewController.swift
//  LeoCommon
//
//  Created by 李理 on 2017/6/5.
//  Copyright © 2017年 李理. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Alamofire

//https://apitest.ichuanyi.com/icyapi.php?appId=3&deviceType=1&fromPageId=0&method=icy.getIconCategoryList&session=BwsIDQNSAAcBDUUDXwABAAQCWgcDCQIHW1cICQ8HBlYPWghcBlMIAgcMXEsIAwNUBVhVAQ0I&userId=1384038328&version=1.7

//Result = {
//    data =     {
//        bottomInfo =         {
//        };
//        list =         (
//            {
//                categoryId = 0;
//                categoryName = "\U5168\U90e8";
//        },
//            {
//                categoryId = 1483600067;
//                categoryName = "\U65f6\U5c1a\U535a\U4e3b";
//        },
//            {
//                categoryId = 1483600072;
//                categoryName = "\U4f18\U8d28icon";
//        },
//            {
//                categoryId = 1483600071;
//                categoryName = "\U660e\U661f";
//        },
//            {
//                categoryId = 1483600069;
//                categoryName = origin;
//        },
//            {
//                categoryId = 1483600066;
//                categoryName = "\U54c6\U5566\U68a6";
//        },
//            {
//                categoryId = 1483600068;
//                categoryName = "icon\U5206\U7c7b";
//        }
//        );
//    };
//    method = "icy.getIconCategoryList";
//    msg =     {
//    };
//    result = 0;
//}

class APIResponse<Model: Mappable>: Mappable {
    var result: Int!
    var method: String!
    var msg: Dictionary<String, Any>!
    var data: Model!
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        data <- map["data"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class CateroryDataModel: Mappable {
    var bottomInfo: Dictionary<String, Any>!
    var list: Array<CategoryModel>!
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        bottomInfo <- map["bottomInfo"]
        list <- map["list"]
    }
}

class CategoryModel: Mappable {
    var categoryId: Int!
    var categoryName: String!
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        categoryId <- map["categoryId"]
        categoryName <- map["categoryName"]
    }
}


class ViewController: UIViewController, APIDelegate {

    private var api:API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        
        self.api = API(basePath: "https://apitest.ichuanyi.com/icyapi.php")
        self.api.apiDelegate = self
//        appId=3&deviceType=1&fromPageId=0&method=icy.getIconCategoryList&session=BwsIDQNSAAcBDUUDXwABAAQCWgcDCQIHW1cICQ8HBlYPWghcBlMIAgcMXEsIAwNUBVhVAQ0I&userId=1384038328&version=1.7
        
        let params:[String : Any] = ["appId": 3, "deviceType": 1, "fromPageId": 0, "method": "icy.getIconCategoryList", "session": "BwsIDQNSAAcBDUUDXwABAAQCWgcDCQIHW1cICQ8HBlYPWghcBlMIAgcMXEsIAwNUBVhVAQ0I&userId=1384038328", "userId": 1384038328, "version": 1.7]
        
//        _ = self.api.fetch(APIResponse<CateroryDataModel>.self, url: "icyapi.php", parameters: params) { (result) in
//            if let error = result.error {
//                debugPrint(error)
//            } else {
//                let value = result.value!
//                debugPrint(value)
//            }
//        }
        
        _ = self.api.rx.fetch(APIResponse<CateroryDataModel>.self, parameters: params).subscribe(onNext: { (response) in
            debugPrint(response)
        }, onError: { (error) in
            debugPrint(error)
        }, onCompleted: {
            debugPrint("Completed!")
        })
    }
    
    public func defaultParameters() -> Parameters? {
        return ["hello": "world"]
    }
}

