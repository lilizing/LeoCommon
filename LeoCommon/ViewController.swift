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
import RxCocoa

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
    
    private var button:UIButton! = nil;
    
    private var disposeBag = DisposeBag()
    
    private var models = Variable<[Int]>([])
    
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.button = UIButton.init(type: .custom)
//        self.button.backgroundColor = .red
//        self.button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100);
//        self.button.setTitle("点击我", for: .normal)
//        self.view.addSubview(self.button)
        
        self.models.asObservable().subscribe(onNext: { (value) in
            debugPrint(value)
        }).addDisposableTo(self.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        self.index += 1
        
    }
    
    public func defaultParameters() -> Parameters? {
        return ["hello": "world"]
    }
}

