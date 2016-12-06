//
//  ChufengNetworking.swift
//  bAFNetworking
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit

class ChufengNetworking: NSObject {
    static func GET(succer suc:(data:NSData)->Void,failed fail:(reason:String)->Void,urlSting:String){
    let manager=AFHTTPSessionManager()
        manager.responseSerializer=AFHTTPResponseSerializer()
        manager.GET(urlSting, parameters: nil, progress: nil, success: { (task, data) in
            //通过suc闭包反传参数
            suc(data: data as! NSData)
            }) { (task, error) in
                fail(reason: error.localizedFailureReason!)
        }
    
    }
    static func POST(succer suc:(data:NSData)->Void,failed fail:(reason:String)->Void,urlString:String,parameters:NSDictionary){
        let manager=AFHTTPSessionManager()
        manager.responseSerializer=AFHTTPResponseSerializer()
        manager.POST(urlString, parameters: parameters, success: { (task, data) in
            suc(data:data as! NSData)
            }) { (task, error) in
                fail(reason: error.localizedFailureReason!)
        }
    }
}
