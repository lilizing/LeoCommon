//
//  StickyHeaderCollectionViewFlowLayout.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/15.
//  Copyright © 2017年 李理. All rights reserved.
//

import UIKit

class FeedViewStickyHeaderViewFlowLayout: UICollectionViewFlowLayout {
    var stickySectionIndexs:[Int] = []
    weak var feedView:FeedView?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var superAttributes = super.layoutAttributesForElements(in: rect), let collectionView = collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let collectionViewTopY = collectionView.contentOffset.y + collectionView.contentInset.top
        let contentOffset = CGPoint(x: 0, y: collectionViewTopY)
        let missingSections = NSMutableIndexSet()
        
        superAttributes.forEach { layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell && layoutAttributes.representedElementKind != UICollectionElementKindSectionHeader {
                missingSections.add(layoutAttributes.indexPath.section)
            }
        }
        
        missingSections.enumerate(using: { idx, stop in
            let indexPath = IndexPath(item: 0, section: idx)
            if let layoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                superAttributes.append(layoutAttributes)
            }
        })
        
        for layoutAttributes in superAttributes {
            if let representedElementKind = layoutAttributes.representedElementKind {
                if representedElementKind == UICollectionElementKindSectionHeader {
                    let section = layoutAttributes.indexPath.section
                    
                    let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
                    
                    let firstCellIndexPath = IndexPath(item: 0, section: section)
                    var lastCellIndexPath = IndexPath(item: max(0, (numberOfItemsInSection - 1)), section: section)
                    
                    var noCell = false
                    let cellAttributes:(first: UICollectionViewLayoutAttributes?, last: UICollectionViewLayoutAttributes?) = {
                        if (collectionView.numberOfItems(inSection: section) > 0) {
                            return (
                                self.layoutAttributesForItem(at: firstCellIndexPath),
                                self.layoutAttributesForItem(at: lastCellIndexPath)
                            )
                        } else {
                            noCell = true
                            
                            let nums = collectionView.numberOfItems(inSection: max(0, section - 1))
                            lastCellIndexPath = IndexPath(item: max(0, (nums - 1)), section: max(0, section - 1))
                            var last:UICollectionViewLayoutAttributes? = nil
                            if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: lastCellIndexPath) {
                                last = header
                            }
                            if nums > 0, let cell = self.layoutAttributesForItem(at: lastCellIndexPath) {
                                last = cell
                            }
                            if let footer = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: lastCellIndexPath) {
                                last = footer
                            }
                            return (
                                nil,
                                last
                                //                                self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: firstCellIndexPath)
                                //                                self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: lastCellIndexPath)
                            )
                        }
                    }()
                    
                    var headerSticky = false
                    if
                        let fv = self.feedView,
                        fv.sectionViewModels.count > section {
                        headerSticky = fv.sectionViewModels[section].headerSticky
                    }
                    
                    let headerHeight = layoutAttributes.frame.height
                    var origin = layoutAttributes.frame.origin
                    // This line makes only one header visible fixed at the top
                    //                    origin.y = min(contentOffset/Users/lili/space/projects/CYZS/Pods/LeoCommon/LeoCommon/LeoCommon/FeedView/FeedViewStickyHeaderViewFlowLayout.swift.y, cellAttributes.last.frame.maxY - headerHeight)
                    // Uncomment this line for normal behaviour:
                    if (self.stickySectionIndexs.contains(section) || headerSticky) {
                        origin.y = contentOffset.y
                        if noCell {
                            if let last = cellAttributes.last {
                                origin.y = max(origin.y, last.frame.maxY)
                            }
                        } else {
                            if let first = cellAttributes.first {
                                origin.y = max(origin.y, first.frame.minY - headerHeight)
                            }
                            if let last = cellAttributes.last {
                                origin.y = min(origin.y, last.frame.maxY - headerHeight)
                            }
                        }
                    }
                    
                    layoutAttributes.zIndex = 1024
                    layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
                }
            }
        }
        
        return superAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

