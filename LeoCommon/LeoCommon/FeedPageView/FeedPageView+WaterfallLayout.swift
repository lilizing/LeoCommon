//
//  FeedPageView+WaterfallLayout.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/16.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ObjectMapper

extension FeedPageView {
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count  {
            return .zero
        }
        if indexPath.section == self.sectionViewModels.count  {
            let cellVM = self.cellViewModelForPage
            let cls = cellVM.cellClass(nil)
            let size = cls.sizeThatFits(cellVM, size: self.bounds.size)
            return size
        }
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    }
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  heightForHeaderInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            if let header = sectionVM.header {
                let cls = header.sectionClass(nil)
                let size = cls.sizeThatFits(header, size:self.bounds.size)
                return size.height
            }
        }
        
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, heightForHeaderInSection: section)
    }
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  heightForFooterInSection section: Int) -> CGFloat {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            if let footer = sectionVM.footer {
                let cls = footer.sectionClass(nil)
                let size = cls.sizeThatFits(footer, size:self.bounds.size)
                return size.height
            }
        }
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, heightForFooterInSection: section)
    }
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count {
            return .zero
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.sectionInset
        }
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
    }
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.minimumInteritemSpacing
        }
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: section)
    }
    
    open override func leo_collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                  columnCountForSection section: Int) -> Int {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.columnCount
        }
        return super.leo_collectionView(collectionView, layout: collectionViewLayout, columnCountForSection: section)
    }
}
