//
//  labelCell.swift
//  momozhushou
//
//  Created by qianfeng on 2016/12/20.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class labelCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.layer.cornerRadius=25
    }

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tagname: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
