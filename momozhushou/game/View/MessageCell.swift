//
//  MessageCell.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var backview: UIView!
  @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
      
        super.awakeFromNib()
        self.backview.layer.cornerRadius = 5
         self.backview.clipsToBounds = true
    }
    func setmodel(_ model:recommendModel)->Void{
//        let model=model1 as! recommendModel
        self.timeL.text=model.create_time
        self.typeL.text=model.category
        self.typeL.layer.borderColor=UIColor.blue.cgColor
        self.typeL.layer.borderWidth=0.8
        self.typeL.layer.cornerRadius=12
        self.icon.sd_setImage(with: URL.init(string: model.icon))
        self.title.text=model.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
