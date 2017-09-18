//
//  FeedViewAlignFlowLayout.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/18.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

public enum FeedViewAlign {
    case left, justified, right
}

open class FeedViewAlignFlowLayout: UICollectionViewFlowLayout {
    
    var align:FeedViewAlign = .left
    weak var delegate:FeedView!
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let array = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
        for attributes in array {
            if attributes.representedElementKind == nil {
                let indexPath = attributes.indexPath;
                attributes.frame = self.layoutAttributesForItem(at: indexPath)!.frame
            }
        }
        return array
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes:UICollectionViewLayoutAttributes?
        
        if self.align == .left {
            if self.scrollDirection == .vertical {
                attributes = self.layoutAttributes(forLeftAlignmentForItemAtIndexPath: indexPath)
            } else {
                attributes = self.layoutAttributes(forTopAlignmentForItemAtIndexPath: indexPath)
            }
        } else if self.align == .left {
            if self.scrollDirection == .vertical {
                attributes = self.layoutAttributes(forRightAlignmentForItemAtIndexPath: indexPath)
            } else {
                attributes = self.layoutAttributes(forBottomAlignmentForItemAtIndexPath: indexPath)
            }
        } else {
            attributes = super.layoutAttributesForItem(at: indexPath)
        }
        return attributes
    }
    
    func layoutAttributes(forLeftAlignmentForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        var frame = attributes.frame
        
        var sectionInset = self.sectionInset
        if let feedView = self.delegate {
            sectionInset = feedView.collectionView(self.collectionView!, layout: self, insetForSectionAt: indexPath.section)
        }
        
        var minimumInteritemSpacing = self.minimumInteritemSpacing
        if let feedView = self.delegate {
            minimumInteritemSpacing = feedView.collectionView(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)
        }
        
        if attributes.frame.origin.x <= sectionInset.left {
            return attributes
        }
        
        if indexPath.item == 0 {
            frame.origin.x = sectionInset.left;
        } else {
            let previousIndexPath = IndexPath.init(item: indexPath.item - 1, section: indexPath.section)
            
            let  previousAttributes = self.layoutAttributesForItem(at: previousIndexPath)!
            
            if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
                frame.origin.x = sectionInset.left;
            } else {
                frame.origin.x = previousAttributes.frame.origin.x + previousAttributes.frame.size.width + minimumInteritemSpacing;
            }
        }
        
        attributes.frame = frame;
        
        return attributes;
    }
    
    func layoutAttributes(forTopAlignmentForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        var frame = attributes.frame
        
        var sectionInset = self.sectionInset
        if let feedView = self.delegate {
            sectionInset = feedView.collectionView(self.collectionView!, layout: self, insetForSectionAt: indexPath.section)
        }
        
        var minimumInteritemSpacing = self.minimumInteritemSpacing
        if let feedView = self.delegate {
            minimumInteritemSpacing = feedView.collectionView(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)
        }
        
        if attributes.frame.origin.y <= sectionInset.top {
            return attributes
        }
        
        if indexPath.item == 0 {
            frame.origin.y = sectionInset.top;
        } else {
            let previousIndexPath = IndexPath.init(item: indexPath.item - 1, section: indexPath.section)
            
            let  previousAttributes = self.layoutAttributesForItem(at: previousIndexPath)!
            
            if (attributes.frame.origin.x > previousAttributes.frame.origin.x) {
                frame.origin.y = sectionInset.top;
            } else {
                frame.origin.y = previousAttributes.frame.origin.y + previousAttributes.frame.size.height + minimumInteritemSpacing;
            }
        }
        
        attributes.frame = frame;
        
        return attributes;
    }
    
    func layoutAttributes(forRightAlignmentForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        var frame = attributes.frame
        
        var sectionInset = self.sectionInset
        if let feedView = self.delegate {
            sectionInset = feedView.collectionView(self.collectionView!, layout: self, insetForSectionAt: indexPath.section)
        }
        
        var minimumInteritemSpacing = self.minimumInteritemSpacing
        if let feedView = self.delegate {
            minimumInteritemSpacing = feedView.collectionView(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)
        }
        
        if frame.origin.x + frame.size.width >= self.collectionViewContentSize.height - sectionInset.right {
            return attributes
        }
        
        if indexPath.item == self.collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
            frame.origin.x = self.collectionViewContentSize.width - sectionInset.right - frame.size.width;
        } else {
            let nextIndexPath = IndexPath.init(item: indexPath.item + 1, section: indexPath.section)
            
            let  nextAttributes = self.layoutAttributesForItem(at: nextIndexPath)!
            
            if attributes.frame.origin.y < nextAttributes.frame.origin.y {
                frame.origin.x = self.collectionViewContentSize.width - sectionInset.right - frame.size.width;
            } else {
                frame.origin.x = nextAttributes.frame.origin.x - minimumInteritemSpacing - attributes.frame.size.width;
            }
        }
        
        attributes.frame = frame;
        
        return attributes;
    }
    
    func layoutAttributes(forBottomAlignmentForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        var frame = attributes.frame
        
        var sectionInset = self.sectionInset
        if let feedView = self.delegate {
            sectionInset = feedView.collectionView(self.collectionView!, layout: self, insetForSectionAt: indexPath.section)
        }
        
        var minimumInteritemSpacing = self.minimumInteritemSpacing
        if let feedView = self.delegate {
            minimumInteritemSpacing = feedView.collectionView(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section)
        }
        
        if frame.origin.y + frame.size.height >= self.collectionViewContentSize.height - sectionInset.left {
            return attributes
        }
        
        if indexPath.item == self.collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
            frame.origin.y = self.collectionViewContentSize.height - sectionInset.bottom - frame.size.height
        } else {
            let nextIndexPath = IndexPath.init(item: indexPath.item + 1, section: indexPath.section)
            
            let  nextAttributes = self.layoutAttributesForItem(at: nextIndexPath)!
            
            if attributes.frame.origin.x < nextAttributes.frame.origin.x {
                frame.origin.y = self.collectionViewContentSize.height - sectionInset.bottom - frame.size.height;
            } else {
                frame.origin.y = nextAttributes.frame.origin.y - minimumInteritemSpacing - attributes.frame.size.height;
            }
        }
        
        attributes.frame = frame;
        
        return attributes;
    }
}
