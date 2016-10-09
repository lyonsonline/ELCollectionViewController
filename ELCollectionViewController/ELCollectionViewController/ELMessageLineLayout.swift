//
//  ELMessageLineLayout.swift
//  ELCollectionViewController
//
//  Created by Lyons Eric on 16/10/2.
//  Copyright © 2016年 Lyons Eric. All rights reserved.
//

import Foundation
import UIKit

//修改图片比例,可随意=.=
fileprivate let ITEM_SIZE_WIDTH: CGFloat = ceil(1020 * SCALE_WIDTH)
fileprivate let ITEM_SIZE_HEIGHT: CGFloat = ceil(450 * SCALE_HEIGHT)

/////返回精确到3位的小数
//func elCeil3f(inNum: CGFloat) -> CGFloat {
//    return CGFloat(Int((inNum + 0.0005) * 1000)) / 1000
//}

class ELMessageLineLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = ceil(54 * SCALE_WIDTH)
        self.itemSize = CGSize(width: ITEM_SIZE_WIDTH, height: ITEM_SIZE_HEIGHT)
        //设置第一个和最后一个居中显示
        let inset = (self.collectionView!.bounds.width - ITEM_SIZE_WIDTH) / 2.0
        self.collectionView?.contentInset = UIEdgeInsets(top: 20, left: inset, bottom: 20, right: inset)
        //是否回弹
        //        self.collectionView?.alwaysBounceHorizontal = true
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
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
