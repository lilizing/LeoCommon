//
//  SYDCollectionView.swift
//  CYZS
//
//  Created by 李理 on 2017/8/24.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

public enum FeedViewLayoutType {
    case flow, water
}

open class FeedView:UIView {
    
    public var collectionView:UICollectionView!
    
    public var registerDict:[String: String] = [:]
    
    fileprivate var disposeBag = DisposeBag()
    fileprivate var sectionInnerDisposeBag = DisposeBag()
    
    public var sectionViewModels:[FeedViewSectionViewModel] = []
    
    public var layoutType:FeedViewLayoutType = .flow
    public var scrollDirection:UICollectionViewScrollDirection = .vertical
    
    public var sticky:Bool = false
    
    //加载器，即：你的业务处理逻辑
    public var loader:(_ page:Int, _ pageSize:Int)->(Void) = { _,_ in }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    private func initCollectionView() {
        if self.layoutType == .water {
            let layout = LEOCollectionViewWaterfallLayout()
            layout.itemRenderDirection = .leoCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight
            self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        } else {
            var layout = UICollectionViewFlowLayout()
            if self.sticky {
                let tLayout = FeedViewStickyHeaderViewFlowLayout()
                tLayout.feedView = self
                layout = tLayout
            }
            layout.scrollDirection = self.scrollDirection
            self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        }
        
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    public init(frame: CGRect, layoutType:FeedViewLayoutType = .flow, scrollDirection:UICollectionViewScrollDirection = .vertical, sticky:Bool = false) {
        super.init(frame: frame)
        self.sticky = sticky
        self.scrollDirection = scrollDirection
        self.layoutType = layoutType
        self.initCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedView:UICollectionViewDelegate {
    
}
