//
//  MessageCell.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var redactL: UILabel!
    @IBOutlet weak var gameicon: UIImageView!
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
