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
    
    var feedPageView:FeedPageView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initActionView()
        
        self.feedPageView = FeedPageView.init(frame: .zero, layoutType: .flow, sticky: true)
        self.feedPageView.pageTabHeight = 44
        self.feedPageView.pageViewHeight = SCREEN_HEIGHT - 108
        self.feedPageView.pageTab.lineHeight = 5
        self.feedPageView.pageTab.lineSpacing = 10
        self.feedPageView.pageTab.lineView.backgroundColor = .green
        self.view.addSubview(self.feedPageView)
        self.feedPageView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.bottom.equalTo(self.view)
        }
        
        
        self.appendSection()
        
        self.appendTabView()
        self.feedPageView.reloadData()
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
        
        _ = view.tapGesture().bind { (_) in
            
            self.appendTabView()
            self.feedPageView.reloadData()
            
        }.addDisposableTo(self.disposeBag)
        
        let view2 = UILabel()
        view2.text = "删除"
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        view2.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(34)
        }
        
        _ = view2.tapGesture().bind { (_) in
            
            self.feedPageView.pageTab.remove(at: 0)
            self.feedPageView.pageView.remove(at: 0)
            
        }.addDisposableTo(self.disposeBag)
    }
    
    func appendSection() {
        var items:[FeedViewCellViewModel] = []
        for i in 1..<8 {
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
        
        self.feedPageView.append(sectionViewModels: [sectionVM])
    }
    
    func appendTabView() {
        var tabs:[DemoPageTabItemView] = []
        var vcs:[DemoFeedView] = []
        
        for i in 0..<1 {
            let tab = DemoPageTabItemView()
            tab.text = "\(i)-\(self.feedPageView.pageTab.items.count)"
            
            let vc = DemoFeedView()
            vc.name = "\(i)-\(self.feedPageView.pageView.items.count)"
            vc.backgroundColor = generateRandomColor()
            
            tabs.append(tab)
            vcs.append(vc)
        }
        
        self.feedPageView.pageTab.insert(contentsOf: tabs, at: 0)
        self.feedPageView.pageView.insert(contentsOf: vcs, at: 0)
    }
    
    func bind() {
        
    }
}
