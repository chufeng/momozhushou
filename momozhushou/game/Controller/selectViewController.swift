//
//  selectViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/13.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class selectViewController: UIViewController {
  var model=recommendModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=model.title
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
             self.navigationItem.backBarButtonItem=UIBarButtonItem.init(title: "返回", style: .done, target: nil, action: nil)
        let font=UIFont.boldSystemFont(ofSize: 12)
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName:font]
         let webview=UIWebView.init(frame: CGRect(x: 0, y: 0,width: SCREEN_W, height: SCREEN_H))
//        let url=NSURL.init(string: model.detail_url)
        webview.loadHTMLString(model.content, baseURL: nil)
//        webview.loadRequest(NSURLRequest.init(URL: url!))
        self.view.addSubview(webview)
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
