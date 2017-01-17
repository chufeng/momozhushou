//
//  AselectViewController.swift
//  momozhushou
//
//  Created by qianfeng on 2016/12/20.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class AselectViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var model1=ADmodel()
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    var model2=TBmodel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden=true
        if model1.attach_thumb != nil{
            
            self.webView.loadHTMLString(model1.content, baseURL: nil)
            
            self.title=model1.title
        }else{
            
            self.webView.loadHTMLString(model2.content, baseURL: nil)
            self.title=model2.title
            
        }

        createTitle()
    }
    func createTitle(){
        if model1.attach_thumb != nil{
            titleL.text=model1.title
            timeL.text=model1.create_time
            authorL.text=model1.nickname
        }else{
            titleL.text=model2.title
            timeL.text=model2.create_time
            authorL.text=model2.copy_from
        }
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
