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

enum FeedViewLayoutType {
    case flow, water
}

class FeedView:UIView {
    
    var collectionView:UICollectionView!
    
    var registerDict:[String: String] = [:]
    
    fileprivate var disposeBag = DisposeBag()
    fileprivate var sectionInnerDisposeBag = DisposeBag()
    
    var sectionViewModels:[FeedViewSectionViewModel] = []
    
    var layoutType:FeedViewLayoutType = .flow
    var scrollDirection:UICollectionViewScrollDirection = .vertical
    
    //加载器，即：你的业务处理逻辑
    var loader:(_ page:Int, _ pageSize:Int)->(Void) = { _,_ in }
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    private func initCollectionView() {
        if self.layoutType == .water {
            let layout = LEOCollectionViewWaterfallLayout()
            layout.itemRenderDirection = .leoCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight
            self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        } else {
            let layout = UICollectionViewFlowLayout()
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
    
    init(frame: CGRect, layoutType:FeedViewLayoutType = .flow, scrollDirection:UICollectionViewScrollDirection = .vertical) {
        super.init(frame: frame)
        self.scrollDirection = scrollDirection
        self.layoutType = layoutType
        self.initCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedView:UICollectionViewDelegate {
    
}
