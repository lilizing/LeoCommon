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

class DemoPageVC:UIViewController {

    var pageTabVC:PageTabVC!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UILabel()
        view.text = "添加"
        view.backgroundColor = .orange
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view).offset(20)
            make.height.equalTo(34)
        }
        
        _ = view.tapGesture().bind { [unowned self] (_) in
            
            var tabs:[DemoPageTabItemView] = []
            var vcs:[DemoFeedVC] = []
            
            for i in 0..<1 {
                let tab = DemoPageTabItemView()
                tab.text = "\(i)-\(self.pageTabVC.pageVC.viewControllers.count)"
                
                let vc = DemoFeedVC()
                vc.name = "\(i)-\(self.pageTabVC.pageVC.viewControllers.count)"
                vc.view.backgroundColor = generateRandomColor()
                
                tabs.append(tab)
                vcs.append(vc)
            }
            
            self.pageTabVC.insert(tabs: tabs, vcs:vcs, at: max(0, self.pageTabVC.pageVC.viewControllers.count - 1))
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: {
//                self.pageTabView.show(at: max(0, self.pageVC.viewControllers.count - 2))
//            })
            }.disposed(by: self.disposeBag)
        
        let view2 = UILabel()
        view2.text = "删除"
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        view2.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(34)
        }
        
        _ = view2.tapGesture().bind { [unowned self] (_) in
            self.pageTabVC.remove(at: max(0, self.pageTabVC.pageVC.viewControllers.count - 2))
        }.disposed(by: self.disposeBag)
        
        
        self.pageTabVC = PageTabVC()
        self.pageTabVC.pageTab.lineView.backgroundColor = .red
        self.pageTabVC.pageTab.lineHeight = 2
        self.pageTabVC.pageTab.lineSpacing = 20
        
        self.addChildViewController(self.pageTabVC)
        self.view.addSubview(self.pageTabVC.view)
        self.pageTabVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.bottom.equalTo(self.view)
        }
        self.pageTabVC.didMove(toParentViewController: self)
    }
    
    func bind() {
        
    }
    
//    deinit {
//        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
//    }
}

func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}
