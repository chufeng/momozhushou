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
    var scrollUporDown=true
    var hidden=true
    var page=1
    var qipao=false
    var oldy:CGFloat=0
    var newy:CGFloat=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        self.navigationItem.backBarButtonItem=UIBarButtonItem.init(title: "返回", style: .done, target: nil, action: nil)
        createT()
        creatData()
        self.automaticallyAdjustsScrollViewInsets=false
        self.navigationController?.navigationBar.alpha=0.6
        
        
    }
    func hdstart(){
               self.performSelector(onMainThread: #selector(self.onMainThread), with: nil, waitUntilDone: true)
        
    }
    func onMainThread(){
        HDManager.startLoading()
    }
     func createT(){
        t.header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
self.reloadData()
            self.creatData()
            
        })
        t.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1

            self.creatData()
        })
        t.separatorStyle = .none
        t.showsHorizontalScrollIndicator=false
        t.delegate=self
        
        t.dataSource=self
        let nib=UINib.init(nibName: "MessageCell", bundle: nil)
        t.register(nib, forCellReuseIdentifier: "MessageCell")
        t.backgroundColor=UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
    }
    func reloadData(){
        dataArray.removeAllObjects()
    }
    func creatData(){
        let thread = Thread(target: self, selector: #selector(self.hdstart), object: nil)
        thread.start()
        
//        "http://mobile.itmo.com/game/commend?&pageSize=10&pageIndex=1"
        let url=NSString.init(format:"http://mobile.itmo.com/news/recommend?pageIndex=%d&pageSize=10", page)
        ChufengNetworking.GET(succer: { (data) in
            
            let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let data1=dict["data"]!as!NSDictionary
            let dataList=data1["dataList"]as! [AnyObject]
                let remodel=recommendModel.arrayOfModels(fromDictionaries: dataList)
            self.dataArray.addObjects(from: remodel as! [recommendModel])
                print(self.dataArray.count)
                        self.t.reloadData()
            
            DispatchQueue.main.async(execute: {
                self.t.reloadData()
                self.t.footer.endRefreshing()
                self.t.header.endRefreshing()
                HDManager.stopLoading()
                
            })
            }, failed: { (reason) in
                print(reason)
                 DispatchQueue.main.async(execute: {
                HDManager.stopLoading()
                    self.t.footer.endRefreshing()
                    self.t.header.endRefreshing()
                    })
                self.showError(withTitle: "更新失败", autoCloseTime: 1)
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
extension leftViewController{
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc=selectViewController()
        vc.model=dataArray[(indexPath as NSIndexPath).section]as!recommendModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView.init(frame: CGRect(x: 0, y: 0, width: 414, height: 5))
        return view
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)as!MessageCell

        let model=dataArray[indexPath.section]
//        let model=data[indexPath.row]
        
//        print(model.count)
        
        cell.setmodel(model as! recommendModel)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if(scrollView==self.t){
            
            newy=scrollView.contentOffset.y
//            print(newy)
            if (newy != oldy){
                if(newy-80>oldy){
                    self.scrollUporDown=true
                }else if(newy+5<oldy){
                    self.scrollUporDown=false
                }
                oldy=newy
            }
            if(self.scrollUporDown){
                self.hidden=true
                UIView.animate(withDuration: 0.5, animations: { 
//                    self.navigationController?.navigationBar.frame=CGRect(x:0, y:-40, width:SCREEN_W, height:40)

                self.tabBarController!.tabBar.frame = CGRect(x: 0 , y: SCREEN_H , width: SCREEN_W, height: 55)

                })
            }else{
                if(self.hidden){
                    UIView.animate(withDuration: 0.5, animations: {
//                        self.navigationController?.navigationBar.frame=CGRect(x:0, y:20, width:SCREEN_W, height:40)
                    self.tabBarController!.tabBar.frame = CGRect(x: 0 , y: SCREEN_H-48, width: SCREEN_W, height: 48)
                    })
                }
            }
        }
    }
}
