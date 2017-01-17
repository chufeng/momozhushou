//
//  randomViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/16.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class randomViewController: UIViewController {
    var tbArray=NSMutableArray()
    var tagArray=NSMutableArray()
    var imgArray=NSMutableArray()
    var tb=UITableView()
    var dateTime=String()
    var page=1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        createTable()
        
        
    }
    func createanimation(){
        let view1=UILabel()
        print("创建成功")
        view1.frame=CGRect(x: 0, y: 64, width: SCREEN_W, height: 21)
        view1.center=CGPoint.init(x: SCREEN_W/2, y: 64+12)
        view1.backgroundColor=UIColor.black

        
        view1.textAlignment = .center
        view1.textColor=UIColor.white
        view1.text=String.init(format: "时间倒回到%@", dateTime)
        UIView.animate(withDuration: 3) {
            view1.alpha=0
            view1.removeFromSuperview()
        }
        
        self.view.addSubview(view1)
        
    }
    func createTable(){
        tb.frame=CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H)
        tb.dataSource=self
        tb.delegate=self
        tb.separatorStyle = .none
        let nib=UINib.init(nibName: "animateCell", bundle: nil)
        tb.register(nib, forCellReuseIdentifier: "animateCell")
        tb.backgroundColor=UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
        tb.header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.reloadData()
            self.loadData()
        })
        tb.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
        })
        
        self.view.addSubview(tb)
    }
    func reloadData(){
        tbArray.removeAllObjects()
        imgArray.removeAllObjects()
        tagArray.removeAllObjects()
    }
    func loadData(){
        
        HDManager.startLoading()
        let url=NSString.init(format:"http://api.aimengniang.com/post/listcount?is_check=20009&limit=20&page=%d&sy=1",page)
        print(url)
        ChufengNetworking.GET(succer: { (data) in
            let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let DATA=dict["data"]as!NSDictionary
            let dataList=DATA["dataList"]
            self.dateTime=DATA["datetime"]as! String
            print(self.dateTime)
            let tbmodel=TBmodel.arrayOfModels(fromDictionaries: dataList as![AnyObject])
            self.tbArray.addObjects(from: tbmodel as! [TBmodel])
//            //tableview的图片和标签
            let datalist=dataList!as![AnyObject]
            for ele in datalist{
                let tag=ele["tags"]
                let tagmodel=tagModel.arrayOfModels(fromDictionaries: tag as! [AnyObject])
                self.tagArray.add(tagmodel)
                let img=ele["image"]as![AnyObject]
                self.imgArray.add(img)
            }
            DispatchQueue.main.async(execute: {
                self.tb.reloadData()
                //                self.createanimation()
                HDManager.stopLoading()
                self.tb.header.endRefreshing()
                self.tb.footer.endRefreshing()
                self.createanimation()
            })
            self.tb.reloadData()
            }, failed: { (reason) in
                print(reason)
                DispatchQueue.main.async(execute: {
                    HDManager.stopLoading()
                    self.tb.footer.endRefreshing()
                    self.tb.header.endRefreshing()
                })
            }, urlSting: url as String)
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
extension randomViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tbArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView.init(frame: CGRect(x: 0, y: 0, width: 414, height: 5))
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "animateCell")as! animateCell
        let model=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        cell.author_img.sd_setImage(with: URL.init(string: model.avatar) as URL!)
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
        let selectvc=AselectViewController()
        let model=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        selectvc.model2=model
        self.navigationController?.pushViewController(selectvc, animated: true)
    }
}
extension randomViewController:animateCellDelegate{
    func animateCellselectedTag(_ cell: animateCell, Index: NSInteger) {
        let vc=TagSelectViewController()
        
        let tagmodel=cell.model1 
        
        vc.model=tagmodel[Index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
