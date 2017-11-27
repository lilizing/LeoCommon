//
//  FeedPageView+FlowLayout.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/16.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

extension FeedPageView  {
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section > self.sectionViewModels.count  {
            return .zero
        }
        if indexPath.section == self.sectionViewModels.count  {
            let cellVM = self.cellViewModelForPage
            let cls = cellVM.cellClass(nil)
            let size = cls.sizeThatFits(cellVM, size: self.bounds.size)
            return size
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > self.sectionViewModels.count {
            return .zero
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.sectionInset
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.minimumLineSpacing
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section > self.sectionViewModels.count {
            return 0
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            return sectionVM.minimumInteritemSpacing
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > self.sectionViewModels.count {
            return .zero
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            if let header = sectionVM.header {
                let cls = header.sectionClass(nil)
                let size = cls.sizeThatFits(header, size:self.bounds.size)
                return size
            }
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section > self.sectionViewModels.count {
            return .zero
        }
        if section == self.sectionViewModels.count {
            let sectionVM = self.sectionViewModelForPage
            if let footer = sectionVM.footer {
                let cls = footer.sectionClass(nil)
                let size = cls.sizeThatFits(footer, size:self.bounds.size)
                return size
            }
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section)
    }
}
