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

open class PageTabVC:UIViewController {
    public var pageTab:PageTabView = PageTabView()
    public var pageVC:PageVC = PageVC()
    
    public var tabHeight:CGFloat = 44
    
    public var disposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        self.view.addSubview(self.pageTab)
        self.pageTab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.tabHeight)
        }
        
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.pageTab.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        self.pageVC.didMove(toParentViewController: self)
        
        self.pageTab.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.pageVC.viewControllers.count > index
                else {
                    return
            }
            
            sSelf.pageVC.selectedIndex = index
        }.addDisposableTo(self.disposeBag)
        
        self.pageVC.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.pageTab.items.count > index
                else {
                    return
            }
            
            sSelf.pageTab.selectedIndex = index
        }.addDisposableTo(self.disposeBag)
    }
    
    public func show(at index:Int) {
        //这里做个演示处理，解决无限联动问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.pageTab.show(at: index)
        }
    }
    
    public func remove(at index:Int) {
        self.pageTab.remove(at: index)
        self.pageVC.remove(at: index)
    }
    
    public func insert(tab: PageTabItemView, vc: UIViewController, at: Int) {
        self.pageTab.insert(newElement: tab, at: at)
        self.pageVC.insert(newElement: vc, at: at)
    }
    
    public func insert(tabs: [PageTabItemView], vcs: [UIViewController], at: Int) {
        self.pageTab.insert(contentsOf: tabs, at: at)
        self.pageVC.insert(contentsOf: vcs, at: at)
    }
}
