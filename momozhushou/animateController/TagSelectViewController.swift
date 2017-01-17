//
//  TagSelectViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/15.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class TagSelectViewController: UIViewController {
    @IBOutlet weak var tb: UITableView!
    @IBOutlet weak var tagtitle: UILabel!
    @IBOutlet weak var tagicon: UIImageView!
    @IBOutlet weak var dataCount: UILabel!
    var model=tagModel()
    var model1=tagModel1()
    var tbArray=NSMutableArray()
    var tagArray=NSMutableArray()
    var imgArray=NSMutableArray()
    var page=1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets=true
        createHview()
        createtb()
        loadData()
    }
    func loadData(){
        HDManager.startLoading()
        var url=NSString()
        if (model.data_count==nil){
        url=NSString.init(format: "http://api.aimengniang.com/tag/news20?limit=10&page=%d&tag_id=%@",page, self.model1.tag_id)
        }else{
        url=NSString.init(format: "http://api.aimengniang.com/tag/news20?limit=10&page=%d&tag_id=%@",page, self.model.tag_id)
        }
        ChufengNetworking.GET(succer: { (data) in
               let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let DATA=dict["data"]as!NSDictionary
            //tableview的文字内容
            let dataList=DATA["dataList"]as!NSDictionary
            let posts=dataList["posts"]
            let tbmodel=TBmodel.arrayOfModels(fromDictionaries: posts as![AnyObject])
            self.tbArray.addObjects(from: tbmodel as! [TBmodel])
            //tableview的图片和标签
            let datalist=posts as![AnyObject]
            for ele in datalist{
                let tag=ele["tags"]
                let tagmodel=tagModel.arrayOfModels(fromDictionaries: tag as! [AnyObject])
                self.tagArray.add(tagmodel)
                let img=ele["image"]as![AnyObject]
                self.imgArray.add(img)
            }
            DispatchQueue.main.async(execute: {
              
                HDManager.stopLoading()
                self.tb.header.endRefreshing()
                self.tb.footer.endRefreshing()
                HDManager.stopLoading()
            })
            self.tb.reloadData()

            }, failed: { (reason) in
                print(reason)
                DispatchQueue.main.async(execute: {
                    self.tb.reloadData()
                    HDManager.stopLoading()
                    self.tb.header.endRefreshing()
                    self.tb.footer.endRefreshing()
                    HDManager.stopLoading()
                })
            }, urlSting: url as String)
    }
    func createHview(){
        if (model.data_count==nil){
            self.tagicon.sd_setImage(with: URL.init(string: model1.attach_file))
            self.tagtitle.text=model1.tag_name
            self.dataCount.text=model1.data_count
        }else{
            self.tagicon.sd_setImage(with: URL.init(string: model.icon))
        self.tagtitle.text=model.tag_name
            self.dataCount.text=model.data_count
        }
    }
    func reloadData(){
        tbArray.removeAllObjects()
        imgArray.removeAllObjects()
        tagArray.removeAllObjects()
    }
    func createtb(){
        tb.delegate=self
        tb.dataSource=self
        tb.header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.reloadData()
            self.loadData()
        })
        tb.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
        })
        tb.backgroundColor=UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
        tb.register(UINib.init(nibName: "animateCell", bundle: nil), forCellReuseIdentifier: "animateCell")
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
extension TagSelectViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView.init(frame: CGRect(x: 0, y: 0, width: 414, height: 5))
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "animateCell")as! animateCell
        let model=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        cell.author_img.sd_setImage(with: URL.init(string: model.avatar))
        cell.authorL.text=model.copy_from
        cell.titleL.text=model.title
        cell.time.text=model.create_time
        cell.delegate=self
        let str1=imgArray[(indexPath as NSIndexPath).section]as![AnyObject]
        let imgarr=[cell.img1,cell.img2,cell.img3]
        for i in 0..<str1.count{
            let img1_1=str1[i]
            let img1=URL.init(string: img1_1 as! String)
            imgarr[i]?.sd_setImage(with: img1)
        }
        let tagmodel=tagArray[(indexPath as NSIndexPath).section]
        cell.setModel(tagmodel as![tagModel])
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击")
        let selectvc=AselectViewController()
        selectvc.model2=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        self.navigationController?.pushViewController(selectvc, animated: true)
    }
}
extension TagSelectViewController:animateCellDelegate{
    func animateCellselectedTag(_ cell: animateCell, Index: NSInteger) {
        let vc=TagSelectViewController()
        
        let tagmodel=cell.model1 
        
        vc.model=tagmodel[Index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
