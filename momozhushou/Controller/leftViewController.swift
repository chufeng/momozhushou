//
//  leftViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class leftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var t: UITableView!
    var dataArray=NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatData()
        createT()
    }
    func createT(){
        t.showsHorizontalScrollIndicator=false
        t.delegate=self
        
        t.dataSource=self
        let nib=UINib.init(nibName: "MessageCell", bundle: nil)
        t.registerNib(nib, forCellReuseIdentifier: "MessageCell")
        t.backgroundColor=UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
    }
    func creatData(){
        let url="http://mobile.itmo.com/game/commend?&pageSize=10&pageIndex=1"
        ChufengNetworking.GET(succer: { (data) in
            
            let dict = try! NSJSONSerialization.JSONObjectWithData(data,options: .AllowFragments)as!NSDictionary
            let data1=dict["data"]!as!NSDictionary
            let dataList=data1["dataList"]as! [AnyObject]
//            print(dataList)
            
                let model=messageModel.arrayOfModelsFromDictionaries(dataList)
            print(model)
                self.dataArray.addObjectsFromArray(model as [AnyObject])
                print(self.dataArray.count)
 
            
            
            self.t.reloadData()
            
            
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
extension leftViewController{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath)as!MessageCell
        let model=dataArray[indexPath.section]as!messageModel
        cell.titleL.text=model.name
        cell.img.sd_setImageWithURL(NSURL.init(string: model.pic))
        cell.contentL.text=model.desc
        cell.gameicon.sd_setImageWithURL(NSURL.init(string: model.cover))
        cell.redactL.text=model.author
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView.init(frame: CGRectMake(0, 0, 414, 5))
        return view
    }
}
