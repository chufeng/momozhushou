//
//  ADmodel.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class ADmodel: JSONModel {
    var content:String!
    var post_id:Int!
    var nickname:String!
    var copy_from:String!
    var attach_thumb:String!
    var title:String!
    var create_time:String!
    var is_alert:Int!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
