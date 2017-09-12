//
//  DemoPageVC.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DemoVC:UIViewController {
    var name:String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.debugLog(self.name + " - *将要显示*")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utils.debugLog(self.name + " - /显示/")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.debugLog(self.name + " - *将要消失*")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Utils.debugLog(self.name + " - /消失/")
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
        if parent != nil {
            Utils.debugLog(self.name + " - *将要添加*")
        } else {
            Utils.debugLog(self.name + " - *将要移除*")
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent != nil {
            Utils.debugLog(self.name + " - /添加/")
        } else {
            Utils.debugLog(self.name + " - /移除/")
        }
    }
}

class DemoPageVC:UIViewController {

    var pageVC:PageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .orange
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(64)
        }
        
        _ = view.tapGesture().bind { (_) in
            let vc = DemoFeedVC()
            vc.name = "页面 - \(self.pageVC.viewControllers.count)"
            vc.view.backgroundColor = generateRandomColor()
            self.pageVC.insert(newElement: vc, at: max(0, self.pageVC.viewControllers.count - 1))
            
            self.pageVC.show(index: max(0, self.pageVC.viewControllers.count - 2))
        }
        
        self.pageVC = PageVC()
        
        self.addChildViewController(self.pageVC)
        
        self.view.addSubview(self.pageVC.view)
        self.pageVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.bottom.equalTo(self.view)
        }
        
        self.pageVC.didMove(toParentViewController: self)
    }
    
    func bind() {
        
    }
}

func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}
