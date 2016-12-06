//
//  leftViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class leftViewController: UIViewController {

    @IBOutlet weak var t: UITableView!
    var dataArraty:NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        creatData()
    }
    func creatData(){
        let url="http://mobile.itmo.com/game/commend?&pageSize=10&pageIndex=1"
        ChufengNetworking.GET(succer: { (data) in
            
            let dict = try! NSJSONSerialization.JSONObjectWithData(data,options: .AllowFragments)as!NSDictionary
            let data1=dict["data"]!as!NSDictionary
            let dataList=data1["dataList"]as![AnyObject]
//            print(dataList)
            
                let model=messageModel.arrayOfModelsFromDictionaries(dataList)
            
                self.dataArraty?.addObject(model)
                print(model)
//                print(i)
            
            
            }, failed: { (reason) in
                print(reason)
            }, urlSting: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
