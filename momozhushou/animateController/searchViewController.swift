//
//  searchViewController.swift
//  momozhushou
//
//  Created by qianfeng on 2016/12/21.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {
    @IBOutlet weak var tb: UITableView!
    var tbArray=NSMutableArray()
    var tagArray=NSMutableArray()
    var imgArray=NSMutableArray()
    var page=1
    @IBOutlet weak var searchtext: UITextField!
    @IBAction func search(_ sender: AnyObject) {
        if (searchtext.text==""){
            createanimation(string: "请输入搜索内容")
        }else{
            loadData()
        }
    }
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.lightGray
        createtable()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    func createtable(){
        tb.dataSource=self
        tb.delegate=self
        tb.separatorStyle = .none
        let nib=UINib.init(nibName: "animateCell", bundle: nil)
        tb.register(nib, forCellReuseIdentifier: "animateCell")
        tb.backgroundColor=UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
        tb.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
        })

    }
    func createanimation(string:String){
        let error=UILabel()
        error.frame=CGRect(x: 0, y: 64, width: SCREEN_W, height: 21)
        error.center=CGPoint.init(x: SCREEN_W/2, y: SCREEN_H/2)
        error.backgroundColor=UIColor.black
        error.textAlignment = .center
        error.textColor=UIColor.white
        error.text=string
        UIView.animate(withDuration: 3) {
            error.alpha=0
            error.removeFromSuperview()
        }
        
        self.view.addSubview(error)
        
    }
    func loadData(){
        
        HDManager.startLoading()
        let url=NSString.init(format:"http://api.aimengniang.com/search?keyword=%@&limit=4&page=%d&type=1",searchtext.text!,page)
        print(url)
        ChufengNetworking.GET(succer: { (data) in
            let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let DATA=dict["data"]as!NSDictionary
            let dataList=DATA["dataList"]as!NSDictionary
            let datas=dataList["datas"]
            let tbmodel=TBmodel.arrayOfModels(fromDictionaries: datas as![AnyObject])
            self.tbArray.addObjects(from: tbmodel as! [TBmodel])
            //tableview的图片和标签
            let datalist=datas!as![AnyObject]
            for ele in datalist{
                let tag=ele["tags"]
                let tagmodel=tagModel.arrayOfModels(fromDictionaries: tag as! [AnyObject])
                self.tagArray.add(tagmodel)
                let img=ele["image"]as![AnyObject]
                self.imgArray.add(img)
            }
            if (self.tbArray.count==0){
                self.createanimation(string: "╮(╯▽╰)╭什么也没搜到啊")
            }
            DispatchQueue.main.async(execute: {
                self.tb.reloadData()
                
                HDManager.stopLoading()
                
                self.tb.footer.endRefreshing()
                
            })
            self.tb.reloadData()
            }, failed: { (reason) in
                print(reason)
                DispatchQueue.main.async(execute: {
                    HDManager.stopLoading()
                    self.tb.footer.endRefreshing()
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension searchViewController:UITableViewDelegate,UITableViewDataSource{
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
        print("点击")
        let selectvc=AselectViewController()
        selectvc.model2=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        self.navigationController?.pushViewController(selectvc, animated: true)
    }
    
}
extension searchViewController:animateCellDelegate{
    func animateCellselectedTag(_ cell: animateCell, Index: NSInteger) {
        let vc=TagSelectViewController()
        let tagmodel=cell.model1
        vc.model=tagmodel[Index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
