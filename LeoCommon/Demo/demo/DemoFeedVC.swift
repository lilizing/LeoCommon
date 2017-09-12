//
//  DemoFeedVC.swift
//  CYZS
//
//  Created by 李理 on 2017/9/6.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DemoFeedVC:UIViewController {
    
    private var feedView:FeedView!
    
    private var maxPage:Int = 5
    
    override func viewDidLoad() {
        self.feedView = FeedView.init(frame: .zero, layoutType: .water)
        self.view.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.feedView.addRefreshHeader()
        self.feedView.addRefreshFooter()
        
        self.feedView.loader = { page, pageSize in
            print("加载数据...")
            
            let delay = DispatchTime.now() + .milliseconds( page == 1 ? 1000 : 200)
            DispatchQueue.global().asyncAfter(deadline: delay, execute: {
                
                DispatchQueue.main.async {
                    
                    var items:[FeedViewCellViewModel] = []
                    
                    if page == 1 {
                        for i in 1..<3 {
                            if i % 2 == 0 {
                                let vm = DemoOneCellViewModel()
                                vm.model = "我是第【一】个Section第【一】种Cell \(i)"
                                items.append(vm)
                            } else {
                                let vm = DemoTwoCellViewModel()
                                vm.model = "我是第【一】个Section第【二】种Cell \(i)"
                                items.append(vm)
                            }
                        }
                        
                        let headerVM = DemoSectionHeaderViewModel()
                        headerVM.text = "我是第【一】个Section的【头部】"
                        
                        let footerVM = DemoSectionFooterViewModel()
                        footerVM.text = "我是第【一】个Section的【尾部】"
                        
                        self.feedView.stopLoading(page, callback: {
                            self.feedView.clear()
                            self.feedView.append(section: 0, headerViewModel: headerVM, footerViewModel: footerVM, cellViewModels: items)
                        })
                    } else {
                        
                        for i in 1..<5 {
                            let vm = DemoThreeCellViewModel()
                            vm.model = "我是第【二】个Section瀑布流Cell \(i)"
                            items.append(vm)
                        }
                        
                        self.feedView.stopLoading(page, hasMore: {
                            return page < self.maxPage
                        }, callback: {
                            if (page == 2) {
                                let headerVM = DemoSectionHeaderViewModel()
                                headerVM.text = "我是第【二】个Section的【头部】"
                                
                                let sectionVM = FeedViewSectionViewModel.init(header: headerVM, footer: nil, items: items)
                                sectionVM.columnCount = 2
                                sectionVM.minimumInteritemSpacing = 5
                                sectionVM.minimumLineSpacing = 5
                                
                                //self.feedView.append(section: 1, headerViewModel: headerVM, footerViewModel: nil, cellViewModels: items)
                                self.feedView.append(sectionViewModels: [sectionVM])
                            } else {
                                self.feedView.append(section: 1, cellViewModels: items)
                            }
                        })
                    }
                    
                }
                
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)   
        self.feedView.headerBeginRefreshing()
    }
}
