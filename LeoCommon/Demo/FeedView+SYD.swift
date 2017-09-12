//
//  FeedView+SYD.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

extension FeedView {
    func addRefreshHeader() {
        self.addRefreshHeader(SYDRefreshHeader.self)
    }
    
    func addRefreshFooter() {
        self.addRefreshFooter(SYDRefreshFooter.self, callback: { footer in
            guard let footer = footer as? SYDRefreshFooter else {
                return
            }
            footer.setTitle("下拉加载更多~", for: .idle)
            footer.setTitle("加载更多~", for: .refreshing)
            footer.setTitle("你碰到我的底线啦~", for: .noMoreData)
        })
    }
}
