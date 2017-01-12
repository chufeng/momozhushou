//
//  tagModel.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/14.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class tagModel: JSONModel {
    var tag_id:String!
    var icon:String!
    
    var tag_name:String!
    var data_count:String!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
class tagModel1: JSONModel {
    var tag_id:String!
    var attach_file:String!
    var tag_name:String!
    var data_count:String!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
}
