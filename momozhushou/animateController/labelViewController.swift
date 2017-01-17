//
//  labelViewController.swift
//  momozhushou
//
//  Created by qianfeng on 2016/12/20.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class labelViewController: UIViewController {
    var tagarray=NSMutableArray()
    var tb=UITableView()
    var page=1
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        loadData()
        
    }
    func createTable(){
        tb.frame=CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H)
        tb.dataSource=self
        tb.delegate=self
        tb.separatorStyle = .none
        let nib=UINib.init(nibName: "labelCell", bundle: nil)
        tb.register(nib, forCellReuseIdentifier: "labelCell")
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
       tagarray.removeAllObjects()
    }
    func loadData(){
        HDManager.startLoading()
        let url="http://api.aimengniang.com/tag/randtags?is_pic=0&nums=20"
        ChufengNetworking.GET(succer: { (data) in
            let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let DATA=dict["data"]as!NSDictionary
            let datalist=DATA["dataList"]as! NSDictionary
            let datas=datalist["datas"]as! [AnyObject]
            self.tagarray=tagModel1.arrayOfModels(fromDictionaries: datas)
            self.tb.reloadData()
            DispatchQueue.main.async(execute: {
                self.tb.reloadData()
                HDManager.stopLoading()
                self.tb.header.endRefreshing()
                self.tb.footer.endRefreshing()
                HDManager.stopLoading()
            })
            }, failed: { (error) in
                DispatchQueue.main.async(execute: {
                    self.tb.reloadData()
                    HDManager.stopLoading()
                    self.tb.header.endRefreshing()
                    self.tb.footer.endRefreshing()
                    HDManager.stopLoading()
                })
                print(error)
            }, urlSting: url)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension labelViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tagarray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView.init(frame: CGRect(x: 0, y: 0, width: 414, height: 5))
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "labelCell")as! labelCell
        let model=tagarray[(indexPath as NSIndexPath).section]as!tagModel1
        cell.tagname.text=model.tag_name
        cell.img.sd_setImage(with:URL.init(string: model.attach_file))
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc=TagSelectViewController()
        let model=tagarray[(indexPath as NSIndexPath).section]as!tagModel1
        
        
        vc.model1=model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
