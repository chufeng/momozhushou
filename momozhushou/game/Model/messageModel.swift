//
//  messageModel.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class messageModel:JSONModel{
    var update_time:String!
    var author:String!
    var download:Int!
    var int_id:String!
    var id:String!
    var extraDataUrl:String!
    var readme:String!
    var islibao:Int!
    var utime:String!
    var apk_version:String!
    var score:String!
//    var image:String!
    var image_num:Int!
    var type:String!
    var wallpaper:String!
    var tag:String!
    var area:String!
    var cover:String!
    var ringtone:String!
    var jpgonglue:String!
    var dataPath:String!
    var furl:String!
    var name:String!
    var ringtone_num:Int!
    var wallpaper_num:Int!
    var is_need_vpn:String!
    var is_online:String!
    var status:String!
    var video:String!
    var content:String!
    var dataSize:String!
    var size:String!
    var mid:Int!
    var desc:String!
    var video_img:String!
    var apk_version_code:String!
    var package:String!
    var pic:String!
    var dataMd5:String!
    var is_need_google_play:String!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
class recommendModel:JSONModel{
    var post_id:String!
    var id:String!
    var title:String!
    var category:String!
    var view_count:String!
    var detail_url:String!
    var create_time:String!
    var icon:String!
    var from:String!
    var content:String!
    var total:String!
    var url:String!
    var time:String!
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
