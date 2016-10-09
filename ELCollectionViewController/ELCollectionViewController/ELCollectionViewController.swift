//
//  ELCollectionViewController.swift
//  ELCollectionViewController
//
//  Created by Lyons Eric on 16/9/27.
//  Copyright © 2016年 Lyons Eric. All rights reserved.
//

import UIKit

protocol ELCollectionViewDelegate: class {
    func ELCollectionViewCenterCell(atIndex: IndexPath)
}
enum ELCollectionType {
    case chat,message
}
class ELCollectionViewController: UIViewController {
    
    weak var elCollectionDelegate: ELCollectionViewDelegate?
    //选择模式
    var elCollectionType: ELCollectionType = .chat
    var dataSource: [Any]!
    var startIndex = IndexPath(item: 0, section: 0)
    
    fileprivate var elCollectionView: UICollectionView! = nil
    fileprivate let bgImageView = UIImageView(frame: CGRect.zero)
    fileprivate var currentIndexPath = IndexPath() {
        didSet {
            guard currentIndexPath != oldValue else {
                return
            }
            elCollectionDelegate?.ELCollectionViewCenterCell(atIndex: currentIndexPath)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initELCollection()
        elCollectionView.scrollToItem(at: startIndex, at: .centeredHorizontally, animated: false)
    }
    ///初始化控件
    func initELCollection() {
        bgImageView.contentMode = .scaleAspectFit
        switch elCollectionType {
            //聊天页面布局
        case .chat:
            elCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ELChatLineLayout())
//            bgImageView.image = #imageLiteral(resourceName: "remind_bg")
            bgImageView.backgroundColor = UIColor(red:0.49, green:0.98, blue:0.95, alpha:1.00)
            elCollectionView.register(ELCollectionViewChatCell.self, forCellWithReuseIdentifier: "Cell")
            //消息页面布局
        case .message:
            elCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ELMessageLineLayout())
//            bgImageView.image = #imageLiteral(resourceName: "remind_bg")
            bgImageView.backgroundColor = UIColor(red:0.69, green:0.43, blue:0.95, alpha:1.00)
            elCollectionView.register(ELCollectionViewMessageCell.self, forCellWithReuseIdentifier: "Cell")
        }
        elCollectionView.dataSource = self
        elCollectionView.delegate = self
        
        initELLayout()
    }
    ///初始化约束
    func initELLayout() {
        elCollectionView.backgroundColor = UIColor.clear
        elCollectionView.showsVerticalScrollIndicator = false
        elCollectionView.showsHorizontalScrollIndicator = false
        elCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.contentMode = .scaleAspectFit
        
        view.addSubview(bgImageView)
        view.addSubview(elCollectionView)
        
        constrain(elCollectionView, bgImageView) { (collectionView, bgImageView) in
            collectionView.center == collectionView.superview!.center
            collectionView.left == collectionView.superview!.left
            collectionView.right == collectionView.superview!.right
            collectionView.height == 400.0 * SCALE_HEIGHT
            bgImageView.edges == inset(bgImageView.superview!.edges, 0)
        }
    }
}
//MARK: - CollectionView
extension ELCollectionViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func configCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        switch elCollectionType {
        case .chat:
            let chatCell = cell as! ELCollectionViewChatCell
            chatCell.unreadNum = "\(indexPath.row)"
        case .message:
            let messageCell = cell as! ELCollectionViewMessageCell
            messageCell.backgroundColor = UIColor.clear
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
//MARK: - ScrollView
extension ELCollectionViewController {
    //用这个可以解决多次点击时,cell并未移动到中间位置的BUG
    //调用scrollToItem用这个函数来获取中间的item
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let array = elCollectionView.indexPathsForVisibleItems.map {  elCollectionView.layoutAttributesForItem(at: $0) }
        let horizontalCenter = scrollView.contentOffset.x + scrollView.bounds.width / 2.0
        var offsetAdjustment: CGFloat = CGFloat(MAXFLOAT)
        for attributes in array {
            let itemHorizontalCenter = attributes!.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        elCollectionView.contentOffset.x += offsetAdjustment
        //更新currentIndex
        let itemPoint = view.convert(elCollectionView.center, to: elCollectionView)
        let indexPath = elCollectionView.indexPathForItem(at: itemPoint)
        guard indexPath != nil else {
            return
        }
        currentIndexPath = indexPath!
    }
    //手指拖动结束而不是点击Item移动结束,使用这个来获取中间Item
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //更新currentIndex
        let itemPoint = view.convert(elCollectionView.center, to: elCollectionView)
        let indexPath = elCollectionView.indexPathForItem(at: itemPoint)
        guard indexPath != nil else {
            return
        }
        currentIndexPath = indexPath!
    }
}
