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

class DemoFeedPageVC:UIViewController {
    
    var feedPageVC:FeedPageVC!
    
    var disposeBag = DisposeBag()
    
    var max = 20
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initActionView()
        
        self.feedPageVC = FeedPageVC.init(layoutType: .flow, sticky: true)
        self.feedPageVC.pageTabInsets = .init(top: 0, left: 0, bottom: 0, right: 50)
        self.feedPageVC.topOffset = 100
        self.feedPageVC.pageTabHeight = 44
        self.feedPageVC.pageViewHeight = SCREEN_HEIGHT - 108
        self.feedPageVC.pageTab.lineHeight = 5
        self.feedPageVC.pageTab.lineSpacing = 10
        self.feedPageVC.pageTab.lineWidth = 12
        self.feedPageVC.pageTab.lineView.backgroundColor = .green
        
        self.feedPageVC.feedPageView.addRefreshHeader()
        
        self.feedPageVC.feedPageView.loader = { [unowned self] page, pageSize in
            self.feedPageVC.clear()
            
            self.appendSection()
            
            self.appendTabView()
            
            self.feedPageVC.reloadData()
            
            self.feedPageVC.feedPageView.stopLoading(nil)
        }
        //注意不要遗漏这个
        self.addChildViewController(self.feedPageVC)
        
        self.view.addSubview(self.feedPageVC.view)
        self.feedPageVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.bottom.equalTo(self.view)
        }
        
        //注意不要遗漏这个
        self.feedPageVC.didMove(toParentViewController: self)
    }
    
    func initActionView() {
        let view = UILabel()
        view.text = "添加"
        view.backgroundColor = .orange
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view).offset(20)
            make.height.equalTo(34)
        }
        
        _ = view.tapGesture().bind { [unowned self] (_) in
            
            self.appendTabView()
            
        }.addDisposableTo(self.disposeBag)
        
        let view2 = UILabel()
        view2.text = "删除"
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        view2.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.centerX.equalTo(self.view)
            make.height.equalTo(34)
        }
        
        _ = view2.tapGesture().bind {[unowned self]  (_) in
            
            self.feedPageVC.removeForPage(at: 0)
            self.feedPageVC.showPage(at: 0)
            
        }.addDisposableTo(self.disposeBag)
        
        let view3 = UILabel()
        view3.text = "删除所有"
        view3.backgroundColor = .blue
        self.view.addSubview(view3)
        view3.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(34)
        }
        
        _ = view3.tapGesture().bind {[unowned self]  (_) in
            
            self.feedPageVC.removeAllForPage()
            
        }.addDisposableTo(self.disposeBag)
    }
    
    func appendSection() {
        var items:[FeedViewCellViewModel] = []
        for i in 1..<2 {
            if i % 2 == 0 {
                let vm = DemoOneCellViewModel()
                vm.model = "Style One Cell \(i)"
                
                
                items.append(vm)
            } else {
                let vm = DemoTwoCellViewModel()
                vm.model = "Style Two Cell \(i)"
                items.append(vm)
            }
        }
        
        let headerVM = DemoSectionHeaderViewModel()
        headerVM.text  = "Section Header"
        
        let footerVM = DemoSectionFooterViewModel()
        footerVM.text = "Section Footer"
        let sectionVM = FeedViewSectionViewModel.init(header: headerVM, footer: footerVM, items: items)
        sectionVM.headerSticky = false
        
        self.feedPageVC.append(sectionViewModels: [sectionVM])
    }
    
    func appendTabView() {
        var tabs:[DemoPageTabItemView] = []
        var vcs:[DemoFeedVC] = []
        
        for i in current..<max {
            let tab = DemoPageTabItemView()
            tab.text = "\(i)"
            
            let vc = DemoFeedVC()
            vc.name = "\(i)"
            vc.view.backgroundColor = generateRandomColor()
            
            tabs.insert(tab, at: 0)
            vcs.insert(vc, at: 0)
        }
        
        self.feedPageVC.topOffset = 100
        self.feedPageVC.pageTabHeight = 44
        self.feedPageVC.pageViewHeight = SCREEN_HEIGHT - 108
        self.feedPageVC.insertForPage(tabs: tabs, vcs: vcs, at: 0)
        self.feedPageVC.showPage(at: 0)
    }
    
    func bind() {
        
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
