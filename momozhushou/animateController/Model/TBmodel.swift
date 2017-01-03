//
//  TBmodel.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/9.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class TBmodel: JSONModel {
    
    var is_collect:Int!
    var copy_from:String!
    var uid:String!
    var image_count:Int!
    var update_time:String!
    var is_follow:Int!
    var image:NSArray!
    var title:String!
    var avatar:String!
    var post_id:Int!
    var view_count:Int!
    var is_good:Int!
    var create_time:String!
    var nickname:String!
    var good_count:Int!
    var content:String!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
