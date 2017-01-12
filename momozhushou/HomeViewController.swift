//
//  HomeViewController.swift
//  momozhushou
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 易达威. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let left=leftViewController()
        let animate=AnimateViewController()
        var viewControllers = [UINavigationController]()
        let nav1=UINavigationController.init(rootViewController: left)
        left.tabBarItem.title="游戏"
        left.tabBarItem.image=ResizeImage(UIImage(named: "G.png")!, targetSize: CGSize(width: 30.0, height: 30.0))
        viewControllers.append(nav1)
        
        
        let nav2=UINavigationController.init(rootViewController: animate)
        animate.tabBarItem.title="动画"
        let aimg=UIImage(named: "A.png")
        let searchimg=ResizeImage(UIImage.init(named: "search.png")!, targetSize: CGSize(width: 20, height: 20))
        let searchbtn=UIBarButtonItem.init(image:searchimg, style: .plain, target: self, action: #selector(self.searchview))
        animate.navigationItem.rightBarButtonItem=searchbtn
        animate.tabBarItem.image=ResizeImage(aimg!, targetSize: CGSize(width: 30.0, height: 30.0))
        viewControllers.append(nav2)
        self.viewControllers=viewControllers
        
        
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
