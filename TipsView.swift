//
//  TipsView.swift
//  BodylogicalCompanion
//
//  Created by Jiqing J Liu on 4/26/17.
//  Copyright © 2017 jiqing. All rights reserved.
//

import UIKit
import MMPopupView
class TipsView: MMPopupView {
    
    static let sharedInstance: TipsView = {
        let sview = TipsView()
        sview.setupTheCustomUI()
        return sview
    }()
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //创建imageView
    lazy var imgeView: UIImageView = UIImageView()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0)
        
        return label
    }()
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 16.0)
        
        return label
    }()
    
    private lazy var custoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 7.0
        view.clipsToBounds = true
        return view
    }()
    
    //将内容添加上界面上,然后设置
    
    
    func setupTheCustomUI()-> Void {
        self.attachedView.mm_dimBackground.addSubview(self.custoView)
        
        self.custoView.addSubview(self.imgeView)
        self.custoView.addSubview(self.titleLabel)
        self.custoView.addSubview(self.detailsLabel)
        //设置约束
        self.imgeView.snp.makeConstraints { (make) in
            make.left.equalTo(self.custoView.snp.left).offset(26)
            make.top.equalTo(self.custoView.snp.top).offset(16)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imgeView.snp.centerY)
            make.left.equalTo(self.imgeView.snp.right).offset(8)
            
        }
        self.detailsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgeView.snp.left)
            make.right.equalTo(self.custoView.snp.right).offset(-26)
            make.top.equalTo(self.imgeView.snp.bottom).offset(16)
        }
        self.custoView.snp.updateConstraints { (make) in
            make.center.equalTo(self.attachedView.mm_dimBackground.snp.center)
            make.bottom.equalTo(self.detailsLabel.snp.bottom).offset(16)
            make.left.equalTo(self.attachedView.mm_dimBackground.snp.left).offset(23)
            make.right.equalTo(self.attachedView.mm_dimBackground.snp.right).offset(-23)
        }
    }

  
}
