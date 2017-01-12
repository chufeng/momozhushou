//
//  AnimateViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class AnimateViewController: BaseViewController
 {
//http://api.aimengniang.com/post/list201?limit=12&page=1&is_check=2030
    var adArray=NSMutableArray()
    var tbArray=NSMutableArray()
    var imgArray=NSMutableArray()
    var tagArray=NSMutableArray()
    var headview=UIView()
    var tb=UITableView()
    var oldy:CGFloat=0
    var newy:CGFloat=0
    var scrollUporDown=true
    var page=1
    var hidden=true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let view1=UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 0))
        self.view.addSubview(view1)
                let searchimg=ResizeImage(UIImage.init(named: "search.png")!, targetSize: CGSize(width: 20, height: 20))
        let searchbtn=UIBarButtonItem.init(image: searchimg, style: .plain, target: self, action: #selector(self.searchview))
//        self.navigationItem.rightBarButtonItem=searchbtn
        self.navigationItem.rightBarButtonItem=searchbtn
        
        creatTable()
        loadData()
    }

    func searchview(){
        print("right")
        let vc=searchViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    lazy var selectorView:UIView={
       let selectorView=UIView.init(frame:CGRect(x: 0, y: 230, width: SCREEN_W, height: 50))

        let randomday=UIView()
        randomday.frame=CGRect(x: 0, y: 0, width: SCREEN_W/3-2, height: 70)
        randomday.backgroundColor=UIColor.white
        let randomimg=UIImage.init(named: "历史.png")
        let randomview=UIImageView(image: randomimg!)
        randomview.frame=CGRect(x: SCREEN_W/6-30, y: 0, width: 60, height: 80)
        randomday.addSubview(randomview)
        selectorView.addSubview(randomday)
        
        let tap=UITapGestureRecognizer.init(target: self, action: #selector(self.random))
        randomday.isUserInteractionEnabled=true
        randomday.addGestureRecognizer(tap)
        
        let ranking=UIView()
        ranking.backgroundColor=UIColor.white
        ranking.frame=CGRect(x: SCREEN_W/3, y: 0, width: SCREEN_W/3-2, height: 70)
        let rankingimg=UIImage.init(named: "热门.png")
        let rankingview=UIImageView(image: rankingimg!)
        rankingview.frame=CGRect(x: SCREEN_W/6-30, y: 0, width: 60, height: 80)
        ranking.addSubview(rankingview)
        selectorView.addSubview(ranking)
        let tap1=UITapGestureRecognizer.init(target: self, action: #selector(self.ranking))
        ranking.isUserInteractionEnabled=true
        ranking.addGestureRecognizer(tap1)
        let label=UIView()
        label.backgroundColor=UIColor.white
        label.frame=CGRect(x: SCREEN_W/3*2, y: 0, width: SCREEN_W/3, height: 70)
        let labelimg=UIImage.init(named: "标签.png")
        let labelview=UIImageView(image: labelimg!)
        labelview.frame=CGRect(x: SCREEN_W/6-30, y: 0, width: 60, height: 80)
        label.addSubview(labelview)
        selectorView.addSubview(label)
        let tap2=UITapGestureRecognizer.init(target: self, action: #selector(self.label))
        label.isUserInteractionEnabled=true
        label.addGestureRecognizer(tap2)
        return selectorView
        
    }()
    func random(){
        let vc=randomViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func ranking(){
        let vc=hotAnimationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func label(){
        let vc=labelViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    lazy var adView:TTCollectionView = {
        let adView = TTCollectionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: 240))
       adView.collectionViewDelegate=self
        adView.timeInterval = 4;
        self.headview.addSubview(adView)
        
        return adView
        
    }()

    func creatTable(){
        headview.frame=CGRect(x: 0, y: 0, width: SCREEN_W, height: 290)
        tb=UITableView.init(frame: CGRect(x: 0, y: 64, width: SCREEN_W, height: SCREEN_H))
        tb.delegate=self
        tb.dataSource=self
        tb.separatorStyle = .none
        self.headview.addSubview(selectorView)
        self.tb.tableHeaderView=headview
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
        adArray.removeAllObjects()
    }
    func loadData()->Void{
        
        HDManager.startLoading()
        let url=NSString.init(format:"http://api.aimengniang.com/post/list201?limit=12&page=%d&is_check=2030",page)
        ChufengNetworking.GET(succer: { (data) in
            self.tb.header.endRefreshing()
            print(1)
            let dict = try! JSONSerialization.jsonObject(with: data as Data,options: .allowFragments)as!NSDictionary
            let DATA=dict["data"]as!NSDictionary
            //轮播图只有第一页才有
            if (self.page==1){
            let showList=DATA["showList"]as![AnyObject]
            
            self.adArray=ADmodel.arrayOfModels(fromDictionaries: showList)
                
            print(showList.count)
            
            var imgArray=[String]()
            var titleArr=[String]()
            for ele in self.adArray{
                imgArray.append((ele as! ADmodel).attach_thumb)
                titleArr.append((ele as! ADmodel).title)
            }
            self.adView.imagesArr=imgArray as [AnyObject]
            self.adView.titleArr=titleArr
            self.adView.imagesCount = imgArray.count
            
            }
            
            //tableview的文字内容
            let dataList=DATA["dataList"]
            let tbarray=TBmodel.arrayOfModels(fromDictionaries: dataList as![AnyObject])
            
            self.tbArray.addObjects(from: tbarray as! [TBmodel])
            
            //tableview的图片和标签
            let datalist=dataList!as![AnyObject]
            for ele in datalist{
                let tag=ele["tags"]
                let tagmodel=tagModel.arrayOfModels(fromDictionaries: tag as! [AnyObject])
                self.tagArray.add(tagmodel)
                let img=ele["image"]as![AnyObject]
                self.imgArray.add(img)
            }
            self.tb.reloadData()
            DispatchQueue.main.async(execute: {
                self.tb.reloadData()
                HDManager.stopLoading()
                self.tb.header.endRefreshing()
                self.tb.footer.endRefreshing()
            })

            }, failed: { (reason) in
                print(reason)
                DispatchQueue.main.async(execute: {
                    HDManager.stopLoading()
                    self.tb.footer.endRefreshing()
                    self.tb.header.endRefreshing()
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
extension AnimateViewController:TTCollectionViewDelegate{
    func cellClick(with index: Int) {
        let selectvc=AselectViewController()
        selectvc.model1=adArray[index]as!ADmodel
        self.navigationController?.pushViewController(selectvc, animated: true)
    }
}
extension AnimateViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print(tbArray.count)
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
        
        cell.setModel(tagmodel as! [tagModel])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectvc=AselectViewController()
        selectvc.model2=tbArray[(indexPath as NSIndexPath).section]as!TBmodel
        self.navigationController?.pushViewController(selectvc, animated: true)
    }
    
    //MARK:滑动tabbar消失
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView==self.tb){
            
            newy=scrollView.contentOffset.y
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
//                    self.navigationController?.navigationBar.frame=CGRectMake(0, -40, SCREEN_W, 40)
                    self.tabBarController!.tabBar.frame = CGRect(x: 0 , y: SCREEN_H , width: SCREEN_W, height: 55)
                    
                })
            }else{
                if(self.hidden){
                    UIView.animate(withDuration: 0.5, animations: {
//                        self.navigationController?.navigationBar.frame=CGRectMake(0, 20, SCREEN_W, 40)
                        self.tabBarController!.tabBar.frame = CGRect(x: 0 , y: SCREEN_H-48, width: SCREEN_W, height: 48)
                    })
                }
            }
        }
    }
}
extension AnimateViewController:animateCellDelegate{
    func animateCellselectedTag(_ cell: animateCell, Index: NSInteger) {
        let vc=TagSelectViewController()
        
        let tagmodel=cell.model1 
        
        vc.model=tagmodel[Index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
