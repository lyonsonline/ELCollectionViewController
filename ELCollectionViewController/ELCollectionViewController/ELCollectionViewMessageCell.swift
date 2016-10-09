//
//  ELCollectionViewMessageCell.swift
//  ELCollectionViewController
//
//  Created by Lyons Eric on 16/10/2.
//  Copyright © 2016年 Lyons Eric. All rights reserved.
//

import Foundation
import UIKit
class ElMessageView: UIView {
    var backgroundView = UIImageView(frame: CGRect.zero)
    var titleIcon = UIImageView(frame: CGRect.zero)
    var titleLabel = UILabel(frame: CGRect.zero)
    var content = UILabel(frame: CGRect.zero)
    var portrait = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        portrait.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.contentMode = .scaleAspectFit
        titleIcon.clipsToBounds = true
        titleIcon.contentMode = .scaleAspectFit
        portrait.clipsToBounds = true
        portrait.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        content.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        content.font = UIFont.systemFont(ofSize: 13)
        content.numberOfLines = 0
        //可以用图片,先用颜色代替啦,不会抠图.
//        backgroundView.image = #imageLiteral(resourceName: "chat_bg_newremind")
        backgroundView.backgroundColor = UIColor(red:0.63, green:0.65, blue:0.76, alpha:1.00)
        
        addSubview(backgroundView)
        addSubview(titleIcon)
        addSubview(titleLabel)
        addSubview(content)
        addSubview(portrait)
        
        constrain(backgroundView, titleIcon, titleLabel, content, portrait) { (backgroundView, titleIcon, titleLabel, content, portrait) in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
            
            titleIcon.left == backgroundView.left + (42 * SCALE_WIDTH)
            titleIcon.top == backgroundView.top + (112 * SCALE_HEIGHT)
            titleIcon.width == (90 * SCALE_WIDTH)
            titleIcon.height == titleIcon.width
            
            titleLabel.left == titleIcon.right + (30 * SCALE_WIDTH)
            titleLabel.centerY == titleIcon.centerY
            titleLabel.width <= backgroundView.width - (42 * SCALE_WIDTH)
            
            content.top == titleIcon.bottom + (42 * SCALE_HEIGHT)
            content.left == titleIcon.left
            content.right <= backgroundView.right - (250 * SCALE_WIDTH)
            content.bottom <= backgroundView.bottom - (42 * SCALE_HEIGHT)
            
            portrait.right == backgroundView.right - (42 * SCALE_WIDTH)
            portrait.bottom == backgroundView.bottom - (42 * SCALE_WIDTH)
            portrait.width == (150 * SCALE_WIDTH)
            portrait.height == portrait.width
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleIcon.layer.rasterizationScale = UIScreen.main.scale
        titleIcon.layer.cornerRadius = titleIcon.bounds.height / 2
        portrait.layer.rasterizationScale = UIScreen.main.scale
        portrait.layer.cornerRadius = portrait.bounds.height / 2
    }
}
class ELCollectionViewMessageCell: UICollectionViewCell {
    private var messageView = ElMessageView(frame: CGRect.zero)
    private var lastTimeLabel = UILabel(frame: CGRect.zero)
    var titleIcon = #imageLiteral(resourceName: "chat_ico_ywbd") {
        didSet {
            messageView.titleIcon.image = titleIcon
        }
    }
    var title = "你好啦" {
        didSet {
            messageView.titleLabel.text = title
        }
    }
    var portrait = #imageLiteral(resourceName: "portrait") {
        didSet {
            messageView.portrait.image = portrait
        }
    }
    var content = "ELCollectionViewMessageCell.swift\nELCollectionViewMessageCell\nCreated by \nLyons Eric on 16/10/2.\nCopyright © 2016年 Lyons Eric. All rights reserved." {
        didSet {
            messageView.content.text = content
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        lastTimeLabel.autoresizingMask = [.flexibleWidth]
        lastTimeLabel.textColor = UIColor.white
        
        messageView.titleIcon.image = titleIcon
        messageView.titleLabel.text = title
        messageView.portrait.image = portrait
        messageView.content.text = content
        lastTimeLabel.font = UIFont.systemFont(ofSize: 12)
        lastTimeLabel.text = "\(Date())"
        
        addSubview(messageView)
        addSubview(lastTimeLabel)
        
        constrain(messageView, lastTimeLabel) { (messageView, lastTimeLabel) in
            messageView.edges == inset(messageView.superview!.edges, 0, 0, 80 * SCALE_HEIGHT, 0)
            lastTimeLabel.centerX == messageView.centerX
            lastTimeLabel.top == messageView.bottom + (10 * SCALE_HEIGHT)
            lastTimeLabel.bottom <= lastTimeLabel.superview!.bottom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
