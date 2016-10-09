//
//  ELChatLineLayout.swift
//  ELCollectionViewController
//
//  Created by Lyons Eric on 16/9/28.
//  Copyright © 2016年 Lyons Eric. All rights reserved.
//

import UIKit

//修改图片比例,可随意=.=
let SCALE_WIDTH = elCeil3f(inNum: UIScreen.main.bounds.width / 1242.0)
let SCALE_HEIGHT = elCeil3f(inNum: UIScreen.main.bounds.height / 2028.0)
fileprivate let ITEM_SIZE_WIDTH: CGFloat = ceil(180 * SCALE_WIDTH)
fileprivate let ITEM_SIZE_HEIGHT: CGFloat = ceil(240.0 * SCALE_HEIGHT)
fileprivate let ZOOM_FACTOR: CGFloat = 0.4
fileprivate let ACTIVE_DISTANCE: CGFloat = ITEM_SIZE_WIDTH

///返回精确到3位的小数
func elCeil3f(inNum: CGFloat) -> CGFloat {
    return CGFloat(Int((inNum + 0.0005) * 1000)) / 1000
}

class ELChatLineLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = ceil(126.0 * SCALE_WIDTH)
        self.itemSize = CGSize(width: ITEM_SIZE_WIDTH, height: ITEM_SIZE_HEIGHT)
        //设置第一个和最后一个居中显示
        let inset = (self.collectionView!.bounds.width - ITEM_SIZE_WIDTH) / 2.0
        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        //是否回弹
//        self.collectionView?.alwaysBounceHorizontal = true
        self.headerReferenceSize = CGSize(width: inset, height: ITEM_SIZE_HEIGHT + 40)
        self.footerReferenceSize = CGSize(width: inset, height: ITEM_SIZE_HEIGHT + 40)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //在Rect范围内的所有Items
        let array = super.layoutAttributesForElements(in: rect)
        guard array != nil else {
            print(array)
            return nil
        }
        var outArray = Array<UICollectionViewLayoutAttributes>()
        //屏幕显示的范围
        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
        for attributes in array! {
            //不加这个会导致快速滑动时会计算尾部sectionView的位置,导致崩溃
            guard attributes.representedElementCategory != .supplementaryView else {
                continue
            }
            let outAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            outArray.append(outAttributes)
            outAttributes.alpha = 0.5
            if rect.contains(outAttributes.frame) {
                let distance = visibleRect.midX - outAttributes.center.x
                let normalizedDistance = distance / ACTIVE_DISTANCE
                if abs(distance) < ACTIVE_DISTANCE {
                    let zoom = 1 + ZOOM_FACTOR * (1 - abs(normalizedDistance))
                    outAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    outAttributes.alpha = 1.0
                    outAttributes.zIndex = 1
                }
            }
        }
        return outArray
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributs = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        attributs?.zIndex = 1
        return attributs
    }
    //自动对齐
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //坐标偏移量
        var offsetAdjustment: CGFloat = CGFloat(MAXFLOAT)
        //水平中线
        let horizontalCenter = proposedContentOffset.x + self.collectionView!.bounds.width / 2.0
        //当前显示区域
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: self.collectionView!.bounds.width, height: self.collectionView!.bounds.height)
        //获取当前显示区域的Items
        let array = super.layoutAttributesForElements(in: targetRect)
        for attributes in array! {
            let itemHorizontalCenter = attributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
