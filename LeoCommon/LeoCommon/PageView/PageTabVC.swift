//
//  PageTabVC.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/13.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

class PageTabVC:UIViewController {
    var tabView:PageTabView = PageTabView()
    var pageVC:PageVC = PageVC()
    
    var tabHeight:CGFloat = 44
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.view.addSubview(self.tabView)
        self.tabView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.tabHeight)
        }
        
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.tabView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        self.pageVC.didMove(toParentViewController: self)
        
        self.tabView.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.pageVC.viewControllers.count > index
                else {
                    return
            }
            
            sSelf.pageVC.show(at: index)
            
        }.addDisposableTo(self.disposeBag)
        
        self.pageVC.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.tabView.items.count > index
                else {
                    return
            }
            
            sSelf.tabView.show(at: index)
        }.addDisposableTo(self.disposeBag)
    }
    
    func show(at index:Int) {
        self.tabView.show(at: index)
        self.pageVC.show(at: index)
    }
    
    func remove(at index:Int) {
        self.tabView.remove(at: index)
        self.pageVC.remove(at: index)
    }
    
    func insert(tab: PageTabItemView, vc: UIViewController, at: Int) {
        self.tabView.insert(newElement: tab, at: at)
        self.pageVC.insert(newElement: vc, at: at)
    }
    
    func insert(tabs: [PageTabItemView], vcs: [UIViewController], at: Int) {
        self.tabView.insert(contentsOf: tabs, at: at)
        self.pageVC.insert(contentsOf: vcs, at: at)
    }
}
