//
//  DemoFeedView.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/16.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

class DemoFeedView:UIView {
    var feedView:FeedPageInnerFeedView!
    private var maxPage:Int = 5
    var name:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.feedView = FeedPageInnerFeedView.init(frame: .zero, layoutType: .flow, sticky: true)
        self.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        //        self.feedView.addRefreshHeader()
        self.feedView.addRefreshFooter()
        
        self.feedView.loader = { [weak self] page, pageSize in
            
            guard let sSelf = self else { return }
            
            print("加载数据...")
            
            let delay = DispatchTime.now() // + .milliseconds( page == 1 ? 1000 : 200)
            DispatchQueue.global().asyncAfter(deadline: delay, execute: {
                
                DispatchQueue.main.async {
                    
                    var items:[FeedViewCellViewModel] = []
                    
                    if page == 1 {
                        for i in 1..<8 {
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
                        headerVM.text  = "------页面【\(String(describing: sSelf.name))】-------"
                        //                        headerVM.text = "我是第【一】个Section的【头部】"
                        
                        let footerVM = DemoSectionFooterViewModel()
                        footerVM.text = "我是第【一】个Section的【尾部】"
                        
                        sSelf.feedView.stopLoading(page, callback: {
                            sSelf.feedView.clear()
                            
                            let sectionVM = FeedViewSectionViewModel.init(header: headerVM, footer: footerVM, items: items)
                            sectionVM.headerSticky = false
                            sSelf.feedView.append(sectionViewModels: [sectionVM])
                        })
                    } else {
                        
                        for i in 1..<5 {
                            let vm = DemoTwoCellViewModel()
                            vm.model = "我是第【二】个Section瀑布流Cell \(i)"
                            items.append(vm)
                        }
                        
                        sSelf.feedView.stopLoading(page, hasMore: {
                            return page < sSelf.maxPage
                        }, callback: {
                            if (page == 2) {
                                let headerVM = DemoSectionHeaderViewModel()
                                headerVM.text = "我是第【二】个Section的【头部】"
                                
                                let sectionVM = FeedViewSectionViewModel.init(header: headerVM, footer: nil, items: items)
                                //                                sectionVM.columnCount = 2
                                sectionVM.minimumInteritemSpacing = 5
                                sectionVM.minimumLineSpacing = 5
                                
                                //self.feedView.append(section: 1, headerViewModel: headerVM, footerViewModel: nil, cellViewModels: items)
                                sSelf.feedView.append(sectionViewModels: [sectionVM])
                            } else {
                                sSelf.feedView.append(section: 1, cellViewModels: items)
                            }
                        })
                    }
                    
                }
                
            })
        }
        
        self.feedView.footerBeginRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
