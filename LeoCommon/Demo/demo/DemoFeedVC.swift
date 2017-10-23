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
    var name:String!
    
    private var feedView:FeedPageInnerFeedView!
    
    private var maxPage:Int = 5
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.feedView = FeedPageInnerFeedView.init(frame: .zero, layoutType: .flow, sticky: true)
        self.view.addSubview(self.feedView)
        self.feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
//        self.feedView.addRefreshHeader()
        self.feedView.addRefreshFooter()
        
        self.feedView.loader = { [weak self] page, pageSize in

            guard let sSelf = self else { return }

            print("加载数据...")

//            let delay = DispatchTime.now() + .milliseconds( page == 1 ? 1000 : 200)
//            DispatchQueue.global().asyncAfter(deadline: delay, execute: {
//
//                DispatchQueue.main.async {

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
                            return true
//                            return page < self.maxPage
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

//                }

//            })
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent != nil {
//            self.feedView.headerBeginRefreshing()
            self.feedView.refresh()
        }
        
        if parent != nil {
            Utils.debugLog(self.name + " - /添加/")
        } else {
            Utils.debugLog(self.name + " - /移除/")
        }
    }
    
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
    
    deinit {
        Utils.debugLog("【内存释放】\(String(describing: self)) dealloc")
    }
    
}
