//
//  ImageUserCell.swift
//  Demo_Code_Layout
//
//  Created by HOANGHUNG on 6/8/17.
//  Copyright © 2017 APPS-CYCLONE. All rights reserved.
//

import UIKit
import SnapKit

class ImageUserCell: UICollectionViewCell {
    
    let imgUser:UIImageView = {
        let image:UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    func setupUI() {
        self.contentView.addSubview(imgUser)
        self.imgUser.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top)
            make.width.equalTo(self.contentView.snp.width)
            make.left.equalTo(self.contentView.snp.left)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
