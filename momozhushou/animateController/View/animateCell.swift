//
//  animateCell.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/9.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit
protocol animateCellDelegate:class {
    
    func animateCellselectedTag(_ cell:animateCell,Index:NSInteger)->Void
}
class animateCell: UITableViewCell {
weak var delegate:animateCellDelegate?
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var author_img: UIImageView!
    var model1=[tagModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        author_img.layer.cornerRadius=7
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    func setModel(_ model:[tagModel])->Void
    {
        self.model1=model
        for view in self.tagView.subviews
        {
            view.removeFromSuperview()
        }
        
        var i = 0
        var orginX : CGFloat = 0
        let btnH :CGFloat = 25
        let btnS :CGSize = CGSize(width: 100, height: 25)
        for tagInfo in model
        {
            
            
            let title:NSString = NSString(string:tagInfo.tag_name)
            let rect = title.boundingRect(with: btnS, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x: orginX + 15, y: 8, width: rect.size.width + 20, height: btnH)
            btn.tag = 1000 + i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            orginX += btn.frame.size.width + 15
            i += 1
            btn.layer.cornerRadius = btnH/2
            btn.layer.borderColor = UIColor.orange.cgColor
            btn.layer.borderWidth = 0.8
            btn.setTitle(title as String, for: UIControlState())
            btn.setTitleColor(UIColor.orange, for: UIControlState())
            self.tagView.addSubview(btn)
            btn.addTarget(self, action: #selector(tagViewDidSelected), for: UIControlEvents.touchUpInside)
            
        }
    }
    func tagViewDidSelected(_ button:UIButton)->Void
    {
        self.delegate?.animateCellselectedTag(self, Index: button.tag - 1000)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

