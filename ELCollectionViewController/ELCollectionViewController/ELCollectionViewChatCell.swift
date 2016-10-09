//
//  ELCollectionViewChatCell.swift
//  ELCollectionViewController
//
//  Created by Lyons Eric on 16/9/30.
//  Copyright © 2016年 Lyons Eric. All rights reserved.
//

import Foundation

class ELProtraitsView: UIView {
    
    var portraits = UIImageView(frame: CGRect.zero)
    var icon = UIView(frame: CGRect.zero)
    var unreadNum = UILabel(frame: CGRect.zero)
    var isIconShow = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build() {
        
        portraits.translatesAutoresizingMaskIntoConstraints = false
        portraits.clipsToBounds = true
        portraits.layer.shouldRasterize = true
        
        //设置未读Label
        unreadNum.translatesAutoresizingMaskIntoConstraints = false
        unreadNum.textAlignment = .center
        unreadNum.textColor = UIColor.white
        unreadNum.backgroundColor = UIColor.clear
        unreadNum.font = UIFont.systemFont(ofSize: 12)
        
        //设置未读图标
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.backgroundColor = UIColor(red:1.00, green:0.47, blue:0.34, alpha:1.00)
        icon.layer.cornerRadius = ceil((60 * SCALE_WIDTH) / 2.0)
        
        icon.isHidden = isIconShow ? false : true
        icon.addSubview(unreadNum)
        addSubview(portraits)
        addSubview(icon)
        
        constrain(portraits, icon, unreadNum) { (portraits, icon, unreadNum) in
            portraits.center == portraits.superview!.center
            portraits.width == portraits.height
            portraits.width <= portraits.superview!.width - 10.0
            portraits.height <= portraits.superview!.height - 10.0
            icon.top == portraits.top
            icon.right == icon.superview!.right
            icon.width == ceil(60 * SCALE_WIDTH)
            icon.height == icon.width
            unreadNum.center == icon.center
            unreadNum.width <= icon.width
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        portraits.layer.rasterizationScale = UIScreen.main.scale
        portraits.layer.cornerRadius = portraits.bounds.height / 2
    }
    
}

class ELCollectionViewChatCell: UICollectionViewCell {
    
    private var portraitsView = ELProtraitsView(frame: CGRect.zero)
    private var userNameLabel = UILabel(frame: CGRect.zero)
    //检测变动
    var userName = "(｡･∀･)ﾉﾞ" {
        didSet {
            userNameLabel.text = userName
        }
    }
    var image = #imageLiteral(resourceName: "portrait") {
        didSet {
            guard image != oldValue else {
                return
            }
            portraitsView.portraits.image = image
        }
    }
    var unreadNum = "" {
        didSet {
            portraitsView.unreadNum.text = unreadNum
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        portraitsView.translatesAutoresizingMaskIntoConstraints = false
        portraitsView.portraits.image = image

        userNameLabel.text = userName
        userNameLabel.font = UIFont.systemFont(ofSize: 14)
        userNameLabel.textColor = UIColor.white
        
        portraitsView.unreadNum.text = unreadNum
        
        addSubview(portraitsView)
        addSubview(userNameLabel)
        
        constrain(portraitsView, userNameLabel) { (portraits, userName) in
            portraits.top == portraits.superview!.top
            portraits.left == portraits.superview!.left
            portraits.right == portraits.superview!.right
            portraits.height == portraits.width
            userName.centerX == userName.superview!.centerX
            userName.top == portraits.bottom + 10
            userName.width <= portraits.width
            userName.bottom <= userName.superview!.bottom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
